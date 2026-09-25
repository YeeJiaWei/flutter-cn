#!/usr/bin/env pwsh
# Usage: irm https://raw.githubusercontent.com/YeeJiaWei/flutter-cn/main/install.ps1 | iex
$ErrorActionPreference = 'Stop'

$DefaultRepo = 'https://github.com/YeeJiaWei/flutter-cn'
$FcnHome = if ($env:FCN_HOME) { $env:FCN_HOME } else { Join-Path $HOME '.fcn' }
$StoreDir = Join-Path $FcnHome 'store'
$BinDir = Join-Path $FcnHome 'bin'
$FcnBin = Join-Path $BinDir 'fcn.exe'
$Asset = 'fcn-windows-x64.exe'

$Repo = if ($env:FCN_REPO) { $env:FCN_REPO } else { $DefaultRepo }

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error 'git is required but not found on PATH.'
    exit 1
}

function Install-Store {
    New-Item -ItemType Directory -Force -Path $FcnHome | Out-Null
    if ((Test-Path $Repo) -and (Test-Path $Repo -PathType Container)) {
        $script:StoreDir = $Repo
        return
    }
    if (Test-Path (Join-Path $StoreDir '.git')) {
        Write-Host "Updating store cache at $StoreDir..."
        git -C $StoreDir pull --ff-only
    } else {
        Write-Host "Cloning store into $StoreDir..."
        if (Test-Path $StoreDir) { Remove-Item -Recurse -Force $StoreDir }
        git clone --depth 1 $Repo $StoreDir
    }
}

function Build-FromSource([string]$Reason) {
    Write-Host "$Reason Building fcn from source instead."

    $dart = Get-Command dart -ErrorAction SilentlyContinue
    if (-not $dart) {
        $flutter = Get-Command flutter -ErrorAction SilentlyContinue
        if ($flutter) {
            $flutterBinDir = Split-Path -Parent $flutter.Source
            $candidate = Join-Path $flutterBinDir 'cache\dart-sdk\bin\dart.exe'
            if (Test-Path $candidate) { $dart = $candidate }
        }
    } else {
        $dart = $dart.Source
    }
    if (-not $dart) {
        Write-Error "Neither dart nor flutter is on PATH; can't build from source."
        exit 1
    }

    Install-Store

    Write-Host 'Building fcn...'
    Push-Location (Join-Path $StoreDir 'cli')
    try {
        & $dart pub get
        New-Item -ItemType Directory -Force -Path $BinDir | Out-Null
        # No -DFCN_VERSION: a source build isn't tied to a release tag, so
        # `fcn --version` falls back to its 'dev' default.
        & $dart compile exe bin/fcn.dart -o $FcnBin
    } finally {
        Pop-Location
    }
}

function Install-Prebuilt {
    $versionTag = if ($env:FCN_VERSION) { $env:FCN_VERSION } else { 'latest' }
    $downloadBase = if ($versionTag -eq 'latest') {
        "$DefaultRepo/releases/latest/download"
    } else {
        "$DefaultRepo/releases/download/$versionTag"
    }

    $tmpDir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid())
    New-Item -ItemType Directory -Force -Path $tmpDir | Out-Null
    try {
        $assetPath = Join-Path $tmpDir $Asset
        $checksumsPath = Join-Path $tmpDir 'checksums.txt'

        Write-Host "Downloading $Asset ($versionTag)..."
        try {
            Invoke-WebRequest -Uri "$downloadBase/$Asset" -OutFile $assetPath -UseBasicParsing
            Invoke-WebRequest -Uri "$downloadBase/checksums.txt" -OutFile $checksumsPath -UseBasicParsing
        } catch {
            return $false
        }

        $expectedLine = Select-String -Path $checksumsPath -Pattern " $Asset$" | Select-Object -First 1
        if (-not $expectedLine) {
            Write-Error "No checksum entry found for $Asset."
            exit 1
        }
        $expected = ($expectedLine.Line -split '\s+')[0]
        $actual = (Get-FileHash -Path $assetPath -Algorithm SHA256).Hash.ToLower()
        if ($expected.ToLower() -ne $actual) {
            Write-Error "Checksum mismatch for $Asset (expected $expected, got $actual)."
            exit 1
        }

        New-Item -ItemType Directory -Force -Path $BinDir | Out-Null
        Copy-Item -Force $assetPath $FcnBin

        Install-Store
        return $true
    } finally {
        Remove-Item -Recurse -Force $tmpDir -ErrorAction SilentlyContinue
    }
}

if ($env:FCN_BUILD_FROM_SOURCE -eq '1') {
    Build-FromSource 'FCN_BUILD_FROM_SOURCE=1.'
} elseif (-not (Install-Prebuilt)) {
    Build-FromSource "No prebuilt release found for $Asset."
}

$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if ($userPath -notlike "*$BinDir*") {
    $newPath = if ($userPath) { "$userPath;$BinDir" } else { $BinDir }
    [Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
    Write-Host "Added $BinDir to your user PATH."
}
$env:Path = "$BinDir;$env:Path"

Write-Host ''
Write-Host "fcn installed: $(& $FcnBin --version 2>$null)"
Write-Host 'Restart your shell so the updated PATH takes effect.'
Write-Host 'Then: cd your_app; fcn init'

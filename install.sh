#!/usr/bin/env bash
set -euo pipefail

DEFAULT_REPO="https://github.com/YeeJiaWei/flutter-cn"

FCN_HOME="${FCN_HOME:-$HOME/.fcn}"
STORE_DIR="$FCN_HOME/store"
BIN_DIR="$FCN_HOME/bin"
FCN_BIN="$BIN_DIR/fcn"
PATH_MARKER="# added by flutter-snippets install.sh"

repo="${FCN_REPO:-$DEFAULT_REPO}"

for cmd in git curl; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "error: $cmd is required but not found on PATH." >&2
    exit 1
  fi
done

detect_asset() {
  os="$(uname -s)"
  arch="$(uname -m)"
  case "$os" in
    Darwin)
      case "$arch" in
        arm64) echo "fcn-macos-arm64" ;;
        x86_64) echo "fcn-macos-x64" ;;
        *) return 1 ;;
      esac
      ;;
    Linux)
      case "$arch" in
        x86_64) echo "fcn-linux-x64" ;;
        *) return 1 ;;
      esac
      ;;
    *)
      return 1
      ;;
  esac
}

sha256_of() {
  if command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | awk '{print $1}'
  elif command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  else
    echo "error: neither shasum nor sha256sum is available to verify the download." >&2
    exit 1
  fi
}

# Accept a plain local path or a file:// URL for FCN_REPO, used only for
# cloning/pulling the snippet store (never for the binary download).
store_repo="$repo"
case "$store_repo" in
  file://*)
    store_repo="${store_repo#file://}"
    ;;
esac

clone_or_pull_store() {
  mkdir -p "$FCN_HOME"
  case "$store_repo" in
    *.git|https://*|http://*|git@*|ssh://*)
      if [ -d "$STORE_DIR/.git" ]; then
        echo "Updating store cache at $STORE_DIR..."
        git -C "$STORE_DIR" pull --ff-only
      else
        echo "Cloning store into $STORE_DIR..."
        rm -rf "$STORE_DIR"
        git clone --depth 1 "$store_repo" "$STORE_DIR"
      fi
      ;;
    *)
      if [ -d "$store_repo" ]; then
        # A plain local directory: use it as the store directly, no clone.
        STORE_DIR="$store_repo"
      elif [ -d "$STORE_DIR/.git" ]; then
        echo "Updating store cache at $STORE_DIR..."
        git -C "$STORE_DIR" pull --ff-only
      else
        echo "Cloning store into $STORE_DIR..."
        rm -rf "$STORE_DIR"
        git clone --depth 1 "$store_repo" "$STORE_DIR"
      fi
      ;;
  esac
}

build_from_source() {
  local reason="$1"
  echo "$reason Building fcn from source instead."

  local dart_bin="dart"
  if ! command -v dart >/dev/null 2>&1; then
    if command -v flutter >/dev/null 2>&1; then
      local flutter_bin_dir
      flutter_bin_dir="$(cd "$(dirname "$(command -v flutter)")" && pwd)"
      if [ -x "$flutter_bin_dir/cache/dart-sdk/bin/dart" ]; then
        dart_bin="$flutter_bin_dir/cache/dart-sdk/bin/dart"
      fi
    fi
    if [ "$dart_bin" = "dart" ] && ! command -v dart >/dev/null 2>&1; then
      echo "error: neither dart nor flutter is on PATH; can't build from source." >&2
      exit 1
    fi
  fi

  clone_or_pull_store

  echo "Building fcn..."
  (cd "$STORE_DIR/cli" && "$dart_bin" pub get)
  mkdir -p "$BIN_DIR"
  # Unset -DFCN_VERSION: a source build isn't tied to a release tag, so `fcn
  # --version` falls back to its 'dev' default.
  (cd "$STORE_DIR/cli" && "$dart_bin" compile exe bin/fcn.dart -o "$FCN_BIN")
}

install_prebuilt() {
  local asset="$1"
  local version_tag="${FCN_VERSION:-latest}"
  local download_base
  if [ "$version_tag" = "latest" ]; then
    download_base="$DEFAULT_REPO/releases/latest/download"
  else
    download_base="$DEFAULT_REPO/releases/download/$version_tag"
  fi

  local tmp_dir
  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "$tmp_dir"' RETURN

  echo "Downloading $asset ($version_tag)..."
  if ! curl -fsSL -o "$tmp_dir/$asset" "$download_base/$asset"; then
    return 1
  fi
  if ! curl -fsSL -o "$tmp_dir/checksums.txt" "$download_base/checksums.txt"; then
    return 1
  fi

  local expected actual
  expected="$(grep " $asset\$" "$tmp_dir/checksums.txt" | awk '{print $1}')"
  actual="$(sha256_of "$tmp_dir/$asset")"
  if [ -z "$expected" ] || [ "$expected" != "$actual" ]; then
    echo "error: checksum mismatch for $asset (expected $expected, got $actual)." >&2
    exit 1
  fi

  mkdir -p "$BIN_DIR"
  mv "$tmp_dir/$asset" "$FCN_BIN"
  chmod +x "$FCN_BIN"
  if [ "$(uname -s)" = "Darwin" ]; then
    xattr -d com.apple.quarantine "$FCN_BIN" 2>/dev/null || true
  fi

  clone_or_pull_store
}

if [ "${FCN_BUILD_FROM_SOURCE:-0}" = "1" ]; then
  build_from_source "FCN_BUILD_FROM_SOURCE=1."
elif asset="$(detect_asset)"; then
  if ! install_prebuilt "$asset"; then
    build_from_source "No prebuilt release found for $asset."
  fi
else
  build_from_source "No prebuilt binary for $(uname -s)/$(uname -m)."
fi

add_path_line() {
  rc_file="$1"
  [ -f "$rc_file" ] || return 0
  if ! grep -qF "$PATH_MARKER" "$rc_file" 2>/dev/null; then
    {
      echo ""
      echo "$PATH_MARKER"
      echo "export PATH=\"$BIN_DIR:\$PATH\""
    } >> "$rc_file"
    echo "Added $BIN_DIR to PATH in $rc_file"
  fi
}

added_to_any=0
for rc in "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.profile"; do
  if [ -f "$rc" ]; then
    add_path_line "$rc"
    added_to_any=1
  fi
done
if [ "$added_to_any" -eq 0 ]; then
  echo "No shell rc file found. Add this to your shell's startup file:"
  echo "  export PATH=\"$BIN_DIR:\$PATH\""
fi

echo ""
echo "fcn installed: $("$FCN_BIN" --version 2>/dev/null || echo "$FCN_BIN")"
echo "Restart your shell, or run: export PATH=\"$BIN_DIR:\$PATH\""
echo "Then: cd your_app && fcn init"

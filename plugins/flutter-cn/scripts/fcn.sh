#!/usr/bin/env bash
# Self-bootstrapping fcn wrapper. Resolves an existing fcn binary, or installs
# one non-interactively, then execs it with the given arguments. Skills and
# the hook call this instead of a bare `fcn`, so installing the plugin is the
# only manual step — nothing else needs a human to run an installer.
set -u

resolve_fcn() {
  if command -v fcn >/dev/null 2>&1; then
    command -v fcn
    return 0
  fi
  if [ -x "${HOME:-}/.fcn/bin/fcn" ]; then
    printf '%s\n' "${HOME}/.fcn/bin/fcn"
    return 0
  fi
  if [ -x "${HOME:-}/.fcn/bin/fcn.exe" ]; then
    printf '%s\n' "${HOME}/.fcn/bin/fcn.exe"
    return 0
  fi
  return 1
}

FCN_BIN="$(resolve_fcn || true)"

if [ -z "$FCN_BIN" ]; then
  echo "[flutter-cn] fcn not found, installing..." >&2

  UNAME_S="$(uname -s 2>/dev/null || echo unknown)"
  case "$UNAME_S" in
    MINGW*|MSYS*|CYGWIN*)
      if ! command -v powershell.exe >/dev/null 2>&1; then
        echo "[flutter-cn] powershell.exe not found; can't install fcn automatically. Install it yourself: irm https://raw.githubusercontent.com/YeeJiaWei/flutter-cn/main/install.ps1 | iex" >&2
        exit 1
      fi
      powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/YeeJiaWei/flutter-cn/main/install.ps1 | iex" 1>&2
      ;;
    *)
      if ! command -v curl >/dev/null 2>&1; then
        echo "[flutter-cn] curl not found; can't install fcn automatically. Install curl (and git) and retry." >&2
        exit 1
      fi
      if ! command -v git >/dev/null 2>&1; then
        echo "[flutter-cn] git not found; can't install fcn automatically. Install git (and curl) and retry." >&2
        exit 1
      fi
      curl -fsSL https://raw.githubusercontent.com/YeeJiaWei/flutter-cn/main/install.sh | bash 1>&2
      ;;
  esac

  FCN_BIN="$(resolve_fcn || true)"
  if [ -z "$FCN_BIN" ]; then
    echo "[flutter-cn] fcn install failed; see the installer output above for the reason." >&2
    exit 1
  fi
fi

exec "$FCN_BIN" "$@"

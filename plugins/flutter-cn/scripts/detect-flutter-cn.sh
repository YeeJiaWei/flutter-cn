#!/usr/bin/env bash
set -u

INPUT="$(cat)"

if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

CWD="$(printf '%s' "$INPUT" | jq -r '.cwd // empty')"
SESSION_ID="$(printf '%s' "$INPUT" | jq -r '.session_id // empty')"
HOOK_EVENT_NAME="$(printf '%s' "$INPUT" | jq -r '.hook_event_name // empty')"

if [ -z "$CWD" ]; then
  exit 0
fi

# Walk up from CWD looking for the first pubspec.yaml.
DIR="$CWD"
PROJECT_ROOT=""
while [ -n "$DIR" ]; do
  if [ -f "$DIR/pubspec.yaml" ]; then
    PROJECT_ROOT="$DIR"
    break
  fi
  if [ "$DIR" = "/" ]; then
    break
  fi
  DIR="$(dirname "$DIR")"
done

if [ -z "$PROJECT_ROOT" ]; then
  exit 0
fi

PUBSPEC="$PROJECT_ROOT/pubspec.yaml"
if ! grep -Eq '^\s*flutter:' "$PUBSPEC" && ! grep -Eq 'sdk: flutter' "$PUBSPEC"; then
  exit 0
fi

MARKER="${TMPDIR:-/tmp}/claude-flutter-cn-${SESSION_ID}"

if [ "$HOOK_EVENT_NAME" = "UserPromptSubmit" ] && [ -f "$MARKER" ]; then
  exit 0
fi

PLUGIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FCN_SH="${PLUGIN_ROOT}/scripts/fcn.sh"

FCN_JSON="$PROJECT_ROOT/fcn.json"
if [ -f "$FCN_JSON" ]; then
  COMPONENTS_DIR="$(jq -r '.dir // "lib/ui/components"' "$FCN_JSON")"
  INSTALLED_COUNT="$(jq -r '.installed | length // 0' "$FCN_JSON" 2>/dev/null || echo 0)"
  cat <<EOF
[flutter-cn] This project uses flutter-cn components in ${COMPONENTS_DIR} (${INSTALLED_COUNT} installed).
- Before writing a new widget, run \`${FCN_SH} docs\` to see if one fits, and reuse installed components from ${COMPONENTS_DIR}.
- Add missing ones with \`${FCN_SH} add <name>\`, not by hand.
- Copied files belong to the project: bind tokens and customise them freely.
EOF
else
  echo "[flutter-cn] flutter-cn components are available; when building UI, run \`${FCN_SH} docs\` and it will set itself up."
fi

touch "$MARKER"

exit 0

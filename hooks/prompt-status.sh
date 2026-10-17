#!/usr/bin/env bash
ROOT_DIR="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
CLI="$ROOT_DIR/bin/carry"
START="${CLAUDE_PROJECT_DIR:-$PWD}"

input="$(cat)"
sid="$(printf '%s' "$input" | tr -d '\n' | sed -n 's/.*"session_id"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"
prompt="$(printf '%s' "$input" | tr -d '\n' | sed -n 's/.*"prompt"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | tr '[:upper:]' '[:lower:]' | sed 's/^[[:space:]]*//; s/[[:space:].!]*$//')"
off="${CARRY_HOME:-$HOME/.carry}/off/${sid:-none}"

CARRY_REPO="$START" "$CLI" where >/dev/null 2>&1 || exit 0

case "$prompt" in
  "carry off") mkdir -p "$(dirname "$off")"; : > "$off"; echo "carry mode is off for this session. The owner says \"carry on\" to bring it back."; exit 0 ;;
  "carry on") rm -f "$off" ;;
esac
[ -f "$off" ] && exit 0

CARRY_REPO="$START" "$CLI" status --line </dev/null 2>/dev/null
exit 0

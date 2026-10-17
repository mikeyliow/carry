#!/usr/bin/env bash
input="$(cat)"
printf '%s' "$input" | grep -Eq 'git[^|;&]*[[:space:]]commit|gh[[:space:]]+pr[[:space:]]+(create|edit)|gh[[:space:]]+issue[[:space:]]+(create|comment)' || exit 0

text="$input"
cwd="$(printf '%s' "$input" | sed -n 's/.*"cwd"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)"
for f in $(printf '%s' "$input" | grep -oE '(-F|--file|--body-file)[ =]+[^ ;&|"\\]+' | sed -E 's/^(-F|--file|--body-file)[ =]+//'); do
  case "$f" in /*) ;; *) f="${cwd:-.}/$f" ;; esac
  [ -f "$f" ] && text="$text
$(cat "$f")"
done

robot="$(printf '\360\237\244\226')"
bad="$(printf '%s' "$text" | LC_ALL=C grep -oiE "co-authored-by|(generated|made|written|created|built) (with|by|using) \[?(claude|codex|chatgpt|copilot|gemini|cursor)|noreply@anthropic\.com|claude-session:|claude\.ai/code|\\\\ud83e\\\\udd16|$robot" | head -1)"
[ -z "$bad" ] && exit 0
printf 'blocked: "%s" in a commit, PR or issue text. No AI attribution anywhere - describe the product change only.\n' "$bad" >&2
exit 2

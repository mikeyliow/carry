#!/usr/bin/env bash
ROOT_DIR="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
CLI="$ROOT_DIR/bin/carry"
START="${CLAUDE_PROJECT_DIR:-$PWD}"

info="$(CARRY_REPO="$START" "$CLI" where 2>/dev/null)" || exit 0

get() { printf '%s\n' "$info" | sed -n "s/^$1=//p"; }

printf 'carry mode is on: repo %s at %s (owner: %s).\n' "$(get repo)" "$(get root)" "$(get owner)"
printf 'Read the carry go skill before any work here: %s. Plan with the owner while no quest is open; once a quest is approved, drive it. Each owner message arrives with a "carry · ..." status line: every open quest, where it stands, what is running.\n' "$(get entry_skill)"
if [ -f "$(get rules)" ]; then printf 'repo rules: %s - read before touching this repo\n' "$(get rules)"
else printf 'repo rules: none yet - the setup skill writes them\n'; fi
printf 'quests: %s\n' "$(get quests)"
case "$(get machine_config)" in *missing*) printf 'machine config: missing - the setup skill asks for it once\n' ;; esac
if command -v carry >/dev/null 2>&1; then
  printf 'cli: carry (on PATH), plugin files: %s\n' "$ROOT_DIR"
else
  printf 'cli: %s (not on PATH - call it by this path), plugin files: %s\n' "$CLI" "$ROOT_DIR"
fi
st="$(CARRY_REPO="$START" "$CLI" status 2>/dev/null)"
open="$(printf '%s\n' "$st" | sed -n '/^linked/q; /waiting on you/p')"
[ -n "$open" ] && { printf 'quests needing the owner:\n'; printf '%s\n' "$open" | sed 's/^/  /'; }
linked="$(printf '%s\n' "$st" | awk 'f && NF >= 4 { split($4, a, ":"); print a[1] } /^linked/ { f = 1 }' | sort -u)"
if [ -n "$linked" ]; then
  repos="$(CARRY_REPO="$START" "$CLI" repos 2>/dev/null)"
  printf 'linked repos, for quests here:\n'
  for r in $linked; do
    p="$(printf '%s\n' "$repos" | awk -v r="$r" '$1 == r { print $2; exit }')"
    printf '  %s %s - if this session cannot read it, restart with: claude --add-dir %s\n' "$r" "${p:-(not set up here)}" "${p:-<path>}"
  done
fi
exit 0

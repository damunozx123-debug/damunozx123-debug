#!/usr/bin/env bash
# Idempotent one-time creation of private GitHub project repositories.
# Does not push sensitive files, delete repositories or change visibility.
set -euo pipefail

OWNER='damunozx123-debug'
if ! command -v gh >/dev/null 2>&1; then
  printf '%s\n' 'Install GitHub CLI first (Termux: pkg install gh; Debian/Ubuntu: sudo apt install gh when available).'
  exit 2
fi
if ! gh auth status >/dev/null 2>&1; then
  gh auth login
fi

while IFS='|' read -r name description; do
  if gh repo view "$OWNER/$name" --json name --jq .name >/dev/null 2>&1; then
    printf 'EXISTS  %s/%s\n' "$OWNER" "$name"
    continue
  fi
  printf 'CREATE  %s/%s (private)\n' "$OWNER" "$name"
  gh repo create "$OWNER/$name" --private --add-readme --description "$description"
done <<'REPOSITORIES'
security-evidence-core|Versioned evidence schemas and authorized network policy libraries
pocketscope-remote|Android-controlled multi-device security assessment companion
trustledger-windows|Read-only Windows configuration and privilege exposure auditing
REPOSITORIES

printf '\nDone. New repositories are private. Copy only audited code and never upload credentials or private evidence.\n'

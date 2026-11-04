#!/usr/bin/env bash
# Fetch the latest agent from user's authenticated private GitHub repository,
# or an explicit ZIP file, and run the one-command installer. No curl|bash.
set -euo pipefail
OWNER_REPO='damunozx123-debug/net-intel-app-v9'
REF='feature/pocketscope-remote-multidevice'
ARCHIVE=''
AGENT_ARGS=()
while (( $# )); do
  case "$1" in
    --archive) ARCHIVE="${2:?missing archive path}"; shift 2 ;;
    --ref) REF="${2:?missing git ref}"; shift 2 ;;
    *) AGENT_ARGS+=("$1"); shift ;;
  esac
done
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
if [[ -n "$ARCHIVE" ]]; then
  if ! command -v python3 >/dev/null 2>&1; then
    if command -v apt-get >/dev/null 2>&1; then
      if [[ "$EUID" -eq 0 ]]; then apt-get update && apt-get install -y python3; else sudo apt-get update && sudo apt-get install -y python3; fi
    else
      echo 'Install Python 3 before extracting this ZIP (package-manager specific).' >&2; exit 2
    fi
  fi
  # Safe ZIP extraction: reject traversal, symlinks, special files, limits.
  python3 - "$ARCHIVE" "$TMP" <<'PY'
import os, pathlib, stat, sys, zipfile
source, dest = sys.argv[1:]
root=pathlib.Path(dest).resolve()
with zipfile.ZipFile(source) as arc:
    items=arc.infolist()
    if len(items)>2000 or sum(i.file_size for i in items)>100_000_000:
        raise SystemExit('archive size limit exceeded')
    for i in items:
        parts=pathlib.PurePosixPath(i.filename).parts
        if not parts or any(p in ('..','') for p in parts) or i.filename.startswith('/') or '\\' in i.filename:
            raise SystemExit('unsafe ZIP path')
        mode=(i.external_attr>>16)
        if stat.S_ISLNK(mode) or stat.S_IFMT(mode) not in (0, stat.S_IFREG, stat.S_IFDIR):
            raise SystemExit('archive contains link/special file')
        target=root.joinpath(*parts).resolve()
        if target!=root and root not in target.parents:
            raise SystemExit('ZIP path escapes destination')
    arc.extractall(root)
PY
  SRC="$(find "$TMP" -type f -path '*/setup/install-linux.sh' -print -quit)"
  [[ -n "$SRC" ]] || { echo 'No PocketScope Linux installer in ZIP.' >&2; exit 2; }
  SRC="$(dirname "$(dirname "$SRC")")"
else
  if ! command -v gh >/dev/null || ! command -v git >/dev/null; then
    echo 'GitHub CLI and/or Git missing: installing from OS package manager...'
    if [[ "$EUID" -eq 0 ]]; then PRIV=(); elif command -v sudo >/dev/null 2>&1; then PRIV=(sudo); else
      echo 'sudo required for package installation.' >&2; exit 2
    fi
    if command -v apt-get >/dev/null 2>&1; then
      "${PRIV[@]}" apt-get update
      "${PRIV[@]}" apt-get install -y git gh ca-certificates
    elif command -v pacman >/dev/null 2>&1; then
      "${PRIV[@]}" pacman -S --needed --noconfirm git github-cli ca-certificates
    elif command -v dnf >/dev/null 2>&1; then
      "${PRIV[@]}" dnf install -y git gh ca-certificates
    elif command -v zypper >/dev/null 2>&1; then
      "${PRIV[@]}" zypper --non-interactive install git gh ca-certificates
    else
      echo 'GitHub CLI is not available via a verified package manager recipe on this OS.' >&2; exit 2
    fi
  fi
  gh auth status >/dev/null 2>&1 || gh auth login
  gh repo clone "$OWNER_REPO" "$TMP/repo" -- --branch "$REF" --depth=1
  SRC="$TMP/repo/pocketscope-remote"
fi
[[ -f "$SRC/setup/install-linux.sh" && -f "$SRC/agent/pocketscope_agent.py" ]] || {
  echo 'Downloaded source does not contain PocketScope agent.' >&2; exit 2;
}
bash "$SRC/setup/install-linux.sh" "${AGENT_ARGS[@]}"
#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APPLY=false

usage() {
  cat <<'EOF'
Usage: bash ~/macos-infra/update.sh [--apply]

Default: fetch and fast-forward the local master branch only.
--apply: additionally run brew bundle against the repository's Brewfile.

Existing dotfile symlinks pointing into the repository pick up changes automatically.
This command does not rerun the initial setup, overwrite local changes, or upgrade
every installed Homebrew package.
EOF
}

case "${1:-}" in
  "") ;;
  --apply) APPLY=true ;;
  -h|--help) usage; exit 0 ;;
  *) usage >&2; exit 2 ;;
esac
if (( $# > 1 )); then usage >&2; exit 2; fi

if [[ ! -d "$REPO_DIR/.git" ]]; then
  echo "Error: not a Git working tree: $REPO_DIR" >&2
  exit 1
fi

if [[ "$(git -C "$REPO_DIR" branch --show-current)" != "master" ]]; then
  echo "Error: switch to the master branch before updating." >&2
  exit 1
fi

if [[ -n "$(git -C "$REPO_DIR" status --porcelain)" ]]; then
  echo "Error: local changes found. Commit or stash them before updating." >&2
  exit 1
fi

echo "Updating macos-infra from origin/master..."
git -C "$REPO_DIR" pull --ff-only origin master

if [[ "$APPLY" == true ]]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "Error: Homebrew is not installed or not on PATH." >&2
    exit 1
  fi
  echo "Applying Brewfile (without cleanup)..."
  brew bundle --file="$REPO_DIR/shells/Brewfile"
fi

echo "Update complete."

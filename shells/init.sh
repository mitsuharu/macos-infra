#!/usr/bin/env bash
set -euo pipefail

SHELLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! xcode-select -p >/dev/null 2>&1; then
  # xcode-select --install は非同期にGUIを開くため、完了待ちなしで後続を実行しない。
  echo "Xcode Command Line Tools が見つかりません。インストール完了後、再度実行してください。" >&2
  xcode-select --install
  exit 1
fi

echo "----------------"
echo "(2) dotfiles"
echo "----------------"
bash "$SHELLS_DIR/dotfiles.sh"

echo "----------------"
echo "(3) homebrew"
echo "----------------"
bash "$SHELLS_DIR/homebrew.sh"

echo "----------------"
echo "(4) anyenv"
echo "----------------"
bash "$SHELLS_DIR/anyenv.sh"

echo "----------------"
echo "(5) devtools"
echo "----------------"
bash "$SHELLS_DIR/devtools.sh"

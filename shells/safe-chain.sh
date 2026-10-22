#!/usr/bin/env bash
set -euo pipefail

SHELLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SHELLS_DIR/safe-chain-release.sh"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
INSTALLER="$TMP_DIR/install-safe-chain.sh"

curl -fsSL "https://github.com/AikidoSec/safe-chain/releases/download/${SAFE_CHAIN_RELEASE}/install-safe-chain.sh" -o "$INSTALLER"
if command -v sha256sum >/dev/null 2>&1; then
  printf '%s  %s\n' "$SAFE_CHAIN_INSTALLER_SHA256" "$INSTALLER" | sha256sum -c -
else
  # macOS標準環境にはsha256sumがないため、同じSHA-256検証をshasumで行う。
  printf '%s  %s\n' "$SAFE_CHAIN_INSTALLER_SHA256" "$INSTALLER" | shasum -a 256 -c -
fi

# 旧方式の環境変数で、検証済みインストーラーの対象バージョンが変わることを防ぐ。
unset SAFE_CHAIN_VERSION
sh "$INSTALLER"
"$HOME/.safe-chain/bin/safe-chain" --version

echo "Safe Chain を有効にするにはターミナルを再起動し、npm safe-chain-verify を実行してください。"

#!/usr/bin/env bash
set -euo pipefail

# corepack enable は使わない。Node.js 25以降はcorepackが梱包されず、Yarn公式もYarn Switchを推奨するため。
# curl | bash にしない。ダウンロード失敗時に set -e で確実に停止させるため。
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
INSTALLER="$TMP_DIR/install-yarn-switch.sh"

echo "Yarn Switch をインストールします"
curl -fsSL https://repo.yarnpkg.com/install -o "$INSTALLER"
bash "$INSTALLER"
"$HOME/.yarn/switch/bin/yarn" switch --version

echo "既定のYarnをダウンロードします"
# 初回のダウンロードをシェルのyarnに任せない。Safe Chainがyarnを自身のプロキシ経由で実行し、
# その証明書をYarn Switch（Rust製）が信頼しないため、ダウンロードが失敗する。
# package.jsonのない一時ディレクトリで実行し、プロジェクト指定ではなく既定のバージョンを取得する。
(cd "$TMP_DIR" && "$HOME/.yarn/switch/bin/yarn" --version)

echo "Yarn Switch を有効にするにはターミナルを再起動し、yarn switch --version を実行してください。"

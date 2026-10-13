#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$HOME/macos-infra"

echo "macOSの開発初期設定を行います"

# gitの起動だけではCLTのインストール案内が出るMacがあるため先に検証する。
if ! xcode-select -p >/dev/null 2>&1; then
  echo "Xcode Command Line Toolsをインストールしてください。完了後、同じcurlコマンドを再実行してください。" >&2
  xcode-select --install
  exit 1
fi

if ! command -v git >/dev/null 2>&1 || ! git --version >/dev/null 2>&1; then
  echo "エラー: Gitが使用できません。Xcode Command Line Toolsの状態を確認してください。" >&2
  exit 1
fi

if [[ -d "$REPO_DIR/.git" ]]; then
  # 既存の変更を勝手に取り込まない。同期はupdate.shから行う。
  echo "既存のリポジトリを使用します: $REPO_DIR"
elif [[ -e "$REPO_DIR" ]]; then
  echo "エラー: $REPO_DIR はGitリポジトリではありません。既存ファイルを保護するため終了します。" >&2
  exit 1
else
  git clone https://github.com/mitsuharu/macos-infra.git "$REPO_DIR"
fi

bash "$REPO_DIR/shells/init.sh"

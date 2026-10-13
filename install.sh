#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$HOME/macos-infra"

echo "macOSの開発初期設定を行います"

if [[ -d "$REPO_DIR/.git" ]]; then
  # 既存の変更を勝手に取得しない。同期はupdate.shで明示的に行う。
  echo "既存のリポジトリを使用します: $REPO_DIR"
elif [[ -e "$REPO_DIR" ]]; then
  echo "エラー: $REPO_DIR はGitリポジトリではありません。既存ファイルを保護するため終了します。" >&2
  exit 1
else
  git clone https://github.com/mitsuharu/macos-infra.git "$REPO_DIR"
fi

bash "$REPO_DIR/shells/init.sh"

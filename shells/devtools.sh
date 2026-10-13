#!/usr/bin/env bash
set -euo pipefail

# macOS標準Rubyにgemを入れると/Library/Ruby/Gemsへの権限が必要になるため、rbenvで実行する。
RBENV_BIN="$HOME/.anyenv/envs/rbenv/bin/rbenv"
if [[ ! -x "$RBENV_BIN" ]]; then
  echo "エラー: rbenv が見つかりません。先に shells/anyenv.sh を実行してください。" >&2
  exit 1
fi

RUBY_VERSION="$("$RBENV_BIN" version-name)"
if [[ "$RUBY_VERSION" == "system" ]]; then
  echo "エラー: rbenv で macOS 標準の Ruby が選択されています。rbenv global でインストール済みRubyを選択してください。" >&2
  exit 1
fi

RUBY_PATH="$("$RBENV_BIN" exec ruby -e 'print RbConfig.ruby')"
case "$RUBY_PATH" in
  "$HOME"/.anyenv/envs/rbenv/versions/*) ;;
  *)
    echo "エラー: rbenv 管理外の Ruby が選択されています: $RUBY_PATH" >&2
    exit 1
    ;;
esac

echo "CocoaPods を rbenv の Ruby ($RUBY_VERSION) にインストールします"
"$RBENV_BIN" exec gem install cocoapods --no-document
"$RBENV_BIN" rehash

# rbenv経由で起動し、システムRuby由来の別のpodコマンドを誤使用しない。
"$RBENV_BIN" exec pod --version
echo "CocoaPods のインストールが完了しました"

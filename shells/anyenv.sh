#!/usr/bin/env bash
set -euo pipefail

RUBY_VER="3.4.7"
NODE_VER="24.13.0"

source ~/.zprofile
wait

# anyenv
echo "anyenv を設定します"
anyenv init
anyenv install --init

source ~/.zprofile
wait

# anyenv update
echo "anyenv update をダウンロードしています"
mkdir -p ~/.anyenv/plugins
git clone https://github.com/znz/anyenv-update.git ~/.anyenv/plugins/anyenv-update

# env
echo "rbenv をインストールします"
anyenv install rbenv

echo "nodenv をインストールします"
anyenv install nodenv

source ~/.zprofile
wait

echo "ruby ${RUBY_VER} をインストールします"
rbenv install -s "${RUBY_VER}"
rbenv rehash
rbenv global "${RUBY_VER}"

# macOS標準Rubyに戻ったままCocoaPodsを入れないよう、選択結果を検証する。
if [[ "$(rbenv version-name)" != "${RUBY_VER}" ]]; then
  echo "エラー: rbenvでRuby ${RUBY_VER} を選択できませんでした" >&2
  exit 1
fi
if [[ "$(rbenv exec ruby -e 'print RbConfig.ruby')" != "$HOME/.anyenv/envs/rbenv/versions/"* ]]; then
  echo "エラー: rbenv管理外のRubyが使用されています" >&2
  exit 1
fi

echo "Node.js ${NODE_VER} をインストールします"
nodenv install -s "${NODE_VER}"
nodenv rehash
nodenv global "${NODE_VER}"

# Node.js 24 までは corepack が梱包されている
corepack enable
# corepack use yarn # プロジェクトごとに設定する

source ~/.zprofile
wait

echo "rbenv-aliases をインストールします"
git clone https://github.com/tpope/rbenv-aliases.git $(rbenv root)/plugins/rbenv-aliases
rbenv alias --auto

echo "nodenv-aliases をインストールします"
git clone https://github.com/nodenv/nodenv-aliases.git $(nodenv root)/plugins/nodenv-aliases
nodenv alias --auto

source ~/.zprofile
wait

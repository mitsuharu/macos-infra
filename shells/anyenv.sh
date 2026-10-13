#!/usr/bin/env bash
set -euo pipefail

RUBY_VER="3.4.7"
NODE_VER="24.13.0"

source ~/.zprofile
wait

# anyenv
echo "anyenv を設定します"
anyenv init
printf 'y\n' | anyenv install --init

source ~/.zprofile
wait

# anyenv update
echo "anyenv update をダウンロードしています"
mkdir -p ~/.anyenv/plugins
if [[ ! -d "$HOME/.anyenv/plugins/anyenv-update/.git" ]]; then
  git clone https://github.com/znz/anyenv-update.git "$HOME/.anyenv/plugins/anyenv-update"
fi

# env
echo "rbenv をインストールします"
if [[ ! -d "$HOME/.anyenv/envs/rbenv" ]]; then anyenv install rbenv; fi

echo "nodenv をインストールします"
if [[ ! -d "$HOME/.anyenv/envs/nodenv" ]]; then anyenv install nodenv; fi

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
if [[ ! -d "$(rbenv root)/plugins/rbenv-aliases/.git" ]]; then
  git clone https://github.com/tpope/rbenv-aliases.git "$(rbenv root)/plugins/rbenv-aliases"
fi
rbenv alias --auto

echo "nodenv-aliases をインストールします"
if [[ ! -d "$(nodenv root)/plugins/nodenv-aliases/.git" ]]; then
  git clone https://github.com/nodenv/nodenv-aliases.git "$(nodenv root)/plugins/nodenv-aliases"
fi
nodenv alias --auto

source ~/.zprofile
wait

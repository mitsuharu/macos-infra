#!/bin/sh

RUBY_VER="3.0.2"
NODE_VER="16.13.0"

source ~/.zprofile

# anyenv
echo "anyenv を設定します"
anyenv init
anyenv install --init

source ~/.zprofile

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

echo "ruby ${RUBY_VER} をインストールします"
rbenv install ${RUBY_VER}
rbenv rehash
rbenv global ${RUBY_VER}

echo "Node.js ${NODE_VER} をインストールします"
nodenv install ${NODE_VER}
nodenv rehash
nodenv global ${NODE_VER}

source ~/.zprofile
wait

echo "nodenv-aliases をインストールします"
git clone https://github.com/nodenv/nodenv-aliases.git $(nodenv root)/plugins/nodenv-aliases
nodenv alias --auto

source ~/.zprofile
wait
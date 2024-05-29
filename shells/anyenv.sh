#!/bin/sh

RUBY_VER="3.2.4"
NODE_VER="20.13.1"

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
rbenv install ${RUBY_VER}
rbenv rehash
rbenv global ${RUBY_VER}

echo "Node.js ${NODE_VER} をインストールします"
nodenv install ${NODE_VER}
nodenv rehash
nodenv global ${NODE_VER}

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

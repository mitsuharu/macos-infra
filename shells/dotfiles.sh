#!/bin/sh

# シンボリックリンクを解除する場合は
# % unlink .zprofile

echo "dotfilesの設定をします"

DOT_DIR="$PWD/macos-infra/dotfiles"
CUR_DIR="$PWD"

echo "- .zprofile の設定をしました"
ln -sf ${DOT_DIR}/.zprofile ~/.zprofile

echo "- .huskyrc の設定をしました"
ln -sf ${DOT_DIR}/.huskyrc ~/.huskyrc

echo "- .npmrc の設定をしました"
ln -sf ${DOT_DIR}/.npmrc ~/.npmrc

echo "dotfilesの設定が完了しました"

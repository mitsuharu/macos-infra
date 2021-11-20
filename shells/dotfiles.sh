#!/bin/sh

# シンボリックリンクを解除する場合は
# % unlink .zprofile

echo "dotfilesの設定をします"

DOT_DIR="$PWD/../dotfiles"
CUR_DIR="$PWD"

echo "- .zprofile の設定をしました"
ln -sf ${DOT_DIR}/.zprofile ~/.zprofile

echo "- .huskyrc の設定をしました"
ln -sf ${DOT_DIR}/.huskyrc ~/.huskyrc

echo "- .npmrc の設定をしました"
ln -sf ${DOT_DIR}/.npmrc ~/.npmrc

echo "- Brewfile の設定をしました"
ln -sf ${CUR_DIR}/Brewfile ~/Brewfile
ln -sf ${CUR_DIR}/Brewfile.lock.json ~/Brewfile.lock.json

echo "dotfilesの設定が完了しました"

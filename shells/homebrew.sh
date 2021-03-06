#!/bin/sh

# Homebrew
echo "Homebrew をインストールします"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

source ~/.zprofile
wait

echo "Brewfile の設定をします"

SHELLS_DIR="$PWD/macos-infra/shells"

ln -sf ${SHELLS_DIR}/Brewfile ~/Brewfile
ln -sf ${SHELLS_DIR}/Brewfile.lock.json ~/Brewfile.lock.json

brew bundle

# java のシンボリック
sudo ln -sfn $(brew --prefix)/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk

source ~/.zprofile
wait
#!/bin/sh


# ruby
echo "Homebrew をインストールします"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

eval "$(/opt/homebrew/bin/brew shellenv)"

brew bundle

# sudo chown -R $(whoami) $(brew --prefix)/*
# brew link openssl --force
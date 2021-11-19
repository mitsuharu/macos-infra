#!/bin/sh

DIR="$PWD/macos-infra/shells"

# ### Command Line Tools
echo "----------------"
echo "(1) Command Line Tools for Xcodeのインストールをします"
echo "----------------"
xcode-select --install

# # dotfiles
echo "----------------"
echo "(2) dotfiles"
echo "----------------"
${DIR}/dotfiles.sh

# ### homebrew
echo "----------------"
echo "(3) homebrew"
echo "----------------"
${DIR}/homebrew.sh

# ### anyenv
echo "----------------"
echo "(4) anyenv"
echo "----------------"
${DIR}/anyenv.sh

### devtool
echo "----------------"
echo "(5) devtools"
echo "----------------"
${DIR}/devtools.sh
#!/bin/sh

DIR="$PWD/shells"

# ### Command Line Tools
# echo "----------------"
# echo "Command Line Tools for Xcodeのインストールをします"
# echo "----------------"
# xcode-select --install

# # dotfiles
# echo "----------------"
# echo "[dotfiles]"
# echo "----------------"
# ${DIR}/dotfiles.sh

# ### homebrew
# echo "----------------"
# echo "[homebrew]"
# echo "----------------"
# ${DIR}/homebrew.sh

# ### anyenv
# echo "----------------"
# echo "[anyenv]"
# echo "----------------"
# ${DIR}/anyenv.sh

### devtool
echo "----------------"
echo "[devtools] $PWD"
echo "----------------"
${DIR}/devtools.sh
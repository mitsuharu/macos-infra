#!/bin/sh

DIR="$HOME/macos-infra"

echo "================================"
echo "macOSの開発初期設定を行います"
echo "================================"

# clone
echo "(A) GitHubからレポジトリをダウンロードしています"
# git clone https://github.com/mitsuharu/macos-infra.git ${DIR}

# install
echo "(B) 開発初期設定を開始します\n"
${DIR}/shells/init.sh

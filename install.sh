#!/bin/sh

DIR="$HOME/macos-infra"

echo "================================"
echo "macOSの開発初期設定を行います"
echo "================================"

# clone
echo "GitHubからレポジトリをダウンロードしています"
# git clone https://github.com/mitsuharu/macos-infra.git ${DIR}

# install
echo "開発初期設定を開始します"
echo "================================"
${DIR}/shells/init.sh

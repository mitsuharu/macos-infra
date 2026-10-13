#!/usr/bin/env bash

# Homebrew
echo "Homebrew をインストールします"

if ! command -v brew >/dev/null 2>&1 && \
   [[ ! -x /opt/homebrew/bin/brew && ! -x /usr/local/bin/brew ]]; then
  # NONINTERACTIVE=1 は確認入力を省略するが、sudoのパスワード入力も行わない。
  # 必要な場合は先にユーザーが管理者認証する。
  if ! sudo -n true 2>/dev/null; then
    echo "Homebrew のインストール前に管理者認証を行います"
    sudo -v
  fi
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew はインストール済みです"
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
else
  echo "Homebrew が見つかりません" >&2
  exit 1
fi

source ~/.zprofile
wait

echo "Brewfile の設定をします"

SHELLS_DIR="$PWD/macos-infra/shells"

ln -sf ${SHELLS_DIR}/Brewfile ~/Brewfile
ln -sf ${SHELLS_DIR}/Brewfile.lock.json ~/Brewfile.lock.json

HOMEBREW_NO_ASK=1 brew bundle

# java のシンボリック
#sudo ln -sfn $(brew --prefix)/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk


echo "pinentry-program $(which pinentry-mac)" >> ~/.gnupg/gpg-agent.conf
killall gpg-agent

source ~/.zprofile
wait

#!/usr/bin/env bash
set -euo pipefail

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

SHELLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -sf "$SHELLS_DIR/Brewfile" "$HOME/Brewfile"
ln -sf "$SHELLS_DIR/Brewfile.lock.json" "$HOME/Brewfile.lock.json"

HOMEBREW_NO_ASK=1 brew bundle --file="$SHELLS_DIR/Brewfile"

# java のシンボリック
#sudo ln -sfn $(brew --prefix)/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
sudo ln -sfn "$(brew --prefix openjdk@17)/libexec/openjdk.jdk" /Library/Java/JavaVirtualMachines/openjdk-17.jdk


mkdir -p "$HOME/.gnupg"
PINENTRY_PATH="$(command -v pinentry-mac)"
touch "$HOME/.gnupg/gpg-agent.conf"
if ! grep -Fxq "pinentry-program $PINENTRY_PATH" "$HOME/.gnupg/gpg-agent.conf"; then
  sed -i.bak '/^pinentry-program /d' "$HOME/.gnupg/gpg-agent.conf"
  echo "pinentry-program $PINENTRY_PATH" >> "$HOME/.gnupg/gpg-agent.conf"
fi
gpgconf --kill gpg-agent || true

source ~/.zprofile
wait

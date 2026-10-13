#!/usr/bin/env bash
set -euo pipefail

DOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../dotfiles" && pwd)"

for name in .zprofile .huskyrc .npmrc; do
  target="$HOME/$name"
  source_file="$DOT_DIR/$name"
  if [[ -L "$target" && "$(readlink "$target")" == "$source_file" ]]; then
    continue
  fi
  if [[ -e "$target" || -L "$target" ]]; then
    # 既存設定を破棄しないよう、リンク作成前に日時付きで退避する。
    backup="$target.backup.$(date +%Y%m%d%H%M%S)"
    if [[ -e "$backup" || -L "$backup" ]]; then
      echo "エラー: バックアップ先が存在します: $backup" >&2
      exit 1
    fi
    mv "$target" "$backup"
    echo "$target を $backup に退避しました"
  fi
  ln -s "$source_file" "$target"
done

source "$HOME/.zprofile"

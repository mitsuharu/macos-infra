# macOS-infra

- macOS のオレオレ開発環境を生成するスクリプト
- macOS Monterey 12.0.1

## Usage

```shell
% bash -c "$(curl -fsSL https://raw.githubusercontent.com/mitsuharu/macos-infra/master/install.sh)"
```

## 他のMacで設定を更新する

初回のセットアップ後、別のMacで次のコマンドを実行すると、`origin/master` の変更を fast-forward で取り込みます。

```sh
bash ~/macos-infra/update.sh
```

Homebrew の Brewfile も適用する場合は、内容を確認してから `--apply` を指定します。

```sh
bash ~/macos-infra/update.sh --apply
```

- 通常の更新は `git pull --ff-only origin master` だけで、インストールスクリプトは再実行しません。
- ローカルに未コミットの変更がある場合や `master` 以外のブランチでは、更新を停止します。
- 既存の dotfiles がリポジトリ内のファイルへのシンボリックリンクであれば、同期した変更は自動的に反映されます。新しいdotfileのリンク作成は行いません。
- `--apply` は `brew bundle` でBrewfileに指定されたツールを導入しますが、Ruby/Node.jsのバージョン変更や全Homebrewパッケージのアップグレードは行いません。
- 複数台で異なる設定を使う場合は、マシンごとの差分を別途管理してください。

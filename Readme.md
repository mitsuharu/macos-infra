# macOS-infra

個人用 macOS 開発環境のセットアップスクリプトです。

> **注意:** 現在の設定は過去のmacOS環境を元に作成されています。新しいMacでの全面的な実行テストは未完了です。実行前に各スクリプトを確認してください。既存の dotfiles をシンボリックリンクに置き換えるため、必要に応じてバックアップしてください。

## セットアップ

```sh
git clone https://github.com/mitsuharu/macos-infra.git ~/macos-infra
cd ~/macos-infra
# スクリプトの内容を確認してから実行
bash install.sh
```

現状のスクリプトにはカレントディレクトリや既存インストール状態に依存する部分があります。上記の手順は自動セットアップ成功を保証するものではありません。特に `install.sh` は既存の `~/macos-infra` があると `git clone` が失敗します。修正するまでは `shells/` 以下の処理を確認し、必要な処理を個別に実行してください。

## CI

`.github/workflows/ci.yml` では以下を実行します。

- Pull Request（作成・更新・再オープン）: `bash -n` によるシェル構文、`zsh -n` によるzprofile構文、`ruby -c` によるBrewfile構文検証

CIはスクリプトを**実行しません**。Homebrew、Ruby、Node.js、CocoaPods、Xcode Command Line Toolsのインストールや、ユーザー環境の書き換えは行いません。CIの成功は新規Macへのセットアップ成功を意味しません。

## 今後の改善候補

- セットアップスクリプトの冪等性（再実行可能性）とパス解決、エラー処理
- `sh` と `bash` の違いによる互換性問題、ShellCheck導入
- Apple Silicon / IntelでのHomebrewパス切り替え
- `.zprofile` のPATH設定、`.npmrc` の古い設定の見直し
- Homebrew・Ruby・Node.jsの新バージョン検出とPR作成
- macOS上でのインストールテスト（隔離された環境で実施）

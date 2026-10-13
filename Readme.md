# macOS-infra

個人用 macOS 開発環境のセットアップスクリプトです。

> **注意:** 現在の設定は過去のmacOS環境を元に作成されています。新しいMacでの全面的な実行テストは未完了です。実行前に各スクリプトを確認してください。既存の dotfiles をシンボリックリンクに置き換えるため、必要に応じてバックアップしてください。

## セットアップ

GitをインストールしていないMacでも、macOS標準の `curl` と `bash` で初期セットアップを起動できます。

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mitsuharu/macos-infra/master/install.sh)"
```

初回にXcode Command Line Toolsが見つからない場合は、macOSのインストールダイアログを開いて処理を終了します。**Command Line Toolsのインストールが完了した後、同じコマンドを再実行してください。** Gitが利用可能なことを確認してから、リポジトリを `~/macos-infra` にcloneします。

すでにリポジトリが存在する場合は、既存のチェックアウトを使用します。更新を取得するには後述の `update.sh` を使ってください。

> `curl` で取得したコードをそのまま実行するため、初回実行前に `install.sh` と `shells/` の内容をGitHubで確認してください。既存環境への影響がある処理を含みます。自動セットアップ全体の実機検証は継続中です。

## CI

`.github/workflows/ci.yml` では以下を実行します。

- Pull Request（作成・更新・再オープン）と毎月1日（日本時間11:17）: `bash -n` によるシェル構文、`zsh -n` によるzprofile構文、`ruby -c` によるBrewfile構文検証

CIはmacOSバージョン・Xcodeバージョン・CPUアーキテクチャをActionsのサマリーに記録します。毎月の実行は環境変化の確認用で、新しいmacOSの公開そのものを検知して通知する機能ではありません。CIはセットアップスクリプトを**実行しません**。Homebrew、Ruby、Node.js、CocoaPods、Xcode Command Line Toolsのインストールや、ユーザー環境の書き換えは行いません。CIの成功は新規Macへのセットアップ成功を意味しません。

## 今後の改善候補

- セットアップスクリプトの冪等性（再実行可能性）とパス解決、エラー処理
- `sh` と `bash` の違いによる互換性問題、ShellCheck導入
- Apple Silicon / IntelでのHomebrewパス切り替え
- `.zprofile` のPATH設定、`.npmrc` の古い設定の見直し
- Homebrew・Ruby・Node.jsの新バージョン検出とPR作成
- macOS上でのインストールテスト（隔離された環境で実施）

## GitHub Actionsの依存関係

GitHub Actionsは完全なコミットSHAで固定し、行末コメントにリリースバージョンを記載します。`.github/dependabot.yml` により、GitHub Actionsの更新を月1回確認してPRを提案します。自動マージは行いません。

## 他のMacで更新する

一度リポジトリを配置したMacでは、次のコマンドで `master` の更新を取り込みます。

```bash
bash ~/macos-infra/update.sh
```

Brewfileに列挙されたツールも適用する場合は `--apply` を付けてください。

```bash
bash ~/macos-infra/update.sh --apply
```

未コミットの変更がある場合や `master` 以外のブランチでは停止します。dotfilesがリポジトリ内のファイルへシンボリックリンクされている場合、ファイル内容の変更は更新時に反映されます。新しいリンクの作成やRuby/Node.jsの変更、初期セットアップの再実行は行いません。

## リリース

GitHub Actionsの「GitHub Release」Workflowは、以下の2つの方法でリリースを作成できます。

- **タグで公開:** `master` の対象コミットに `v1.0.0` 形式のタグを作成・pushする。
- **手動で公開:** GitHubの **Actions → GitHub Release → Run workflow** を開き、`master` を選び、`version` に `v1.0.0` 形式を指定する。

どちらもGitHub Releaseを公開し、前回のリリースからマージされたPull RequestをGitHub標準の自動生成リリースノートに含めます。カテゴリは `.github/release.yml` のラベル設定に従います。タグ・リリースは一度公開した後に自動上書きしません。

手動実行は未使用タグを新規作成するため、**同じタグを事前にpushしないでください**。タグを先にpushした場合はタグのWorkflowが実行されます。実行前に通常CIと実インストールCIの成功を確認してください（リリースWorkflow自身はインストールテストを再実行しません）。

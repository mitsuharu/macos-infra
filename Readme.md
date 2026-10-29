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

## 初期インストールのバージョン

Ruby と Node.js のバージョンは `shells/runtime-versions.sh` で管理します。`RUBY_VER` または `NODE_VER` の1行を変更すると、初期インストールと実インストールCIの検証に同じ値が反映されます。このファイルの変更も実インストールCIの実行対象です。

既存のMacにインストール済みのバージョンは、この設定の変更や `update.sh --apply` だけでは切り替わりません。

## Yarn

Yarnは[Yarn Switch](https://v6.yarnpkg.com/)で導入します。Node.js 25以降はcorepackが梱包されないため、`corepack enable` は使用しません。初期セットアップでは `shells/yarn-switch.sh` が公式インストーラー（`https://repo.yarnpkg.com/install`）を一時ディレクトリにダウンロードして実行し、`~/.yarn/switch/bin/yarn` に配置します。

公式インストーラーは `~/.yarn/switch/env` を作成し、`.zshrc` / `.bashrc` の末尾に読み込み処理を追記します（既に追記済みなら変更しません）。`.zshrc` を読まない非対話のログインシェルでも使えるよう、`dotfiles/.zprofile` でも `~/.yarn/switch/bin` をPATHの先頭に追加しています。完了後はターミナルを再起動して確認してください。

```bash
yarn switch --version
```

導入済みのMacで追加・更新する場合は、リポジトリを更新後、次を実行します（`update.sh` はYarn Switchを導入・更新しません）。再実行すると最新の安定版で上書きされます。

```bash
bash ~/macos-infra/shells/yarn-switch.sh
```

使用するYarnのバージョンはプロジェクトの `package.json` の `packageManager` で指定します。既存プロジェクトの移行は `yarn switch zpm set version zpm`、更新は `yarn switch up` を実行します。

## Safe Chain

初期セットアップでは、[Aikido Safe Chainの公式Unix/Linux/macOS手順](https://github.com/AikidoSec/safe-chain#unixlinuxmacos)に従い、バージョン固定のインストーラーをダウンロードし、SHA-256が一致した場合だけ `sh` で実行します。macOS標準環境では `sha256sum` の代わりに `shasum -a 256` で同じ検証を行います。ダウンロード用の一時ディレクトリは成功・失敗時ともに削除します。

インストール先は `~/.safe-chain` です。公式インストーラーは `.zshrc` / `.bashrc` などのシェル設定に読み込み処理を追加します。既存のnpm・Volta・nvm経由のSafe Chainがある場合、公式処理で移行されることがあります。完了後はターミナルを再起動して確認してください。

```bash
safe-chain --version
npm safe-chain-verify
```

`OK: Safe-chain works!` と表示されればシェル統合が有効です。`update.sh --apply` はSafe Chainを更新しません。既存Macで導入・更新する場合は、リポジトリを更新後、次を実行します。

```bash
bash ~/macos-infra/shells/safe-chain.sh
```

### 月次の更新確認

`.github/workflows/safe-chain-update.yml` は毎月1日11:31（日本時間）に公式READMEと最新の正式リリースを確認します。Actionsの「Safe Chainの月次更新」から `master` を選んで手動実行することもできます。

- バージョンとハッシュの管理先は `shells/safe-chain-release.sh` です。公式READMEと取得したインストーラーのSHA-256を照合し、変更がある場合だけ更新PRを作成します。同じ内容のPRは再作成せず、自動マージもしません。
- 公式手順の形式変更、READMEと最新リリースの不一致、ハッシュ不一致、通信エラーでは更新を止めてWorkflowを失敗させます。Actionsの失敗通知を有効にして、手順の見直しが必要か確認してください。
- PR作成にはリポジトリの **Settings → Actions → General → Workflow permissions → Allow GitHub Actions to create and approve pull requests** を有効にする必要があります。トークンの権限は更新ジョブの `contents: write` と `pull-requests: write` に限定しています。
- 自動作成PRのCIが承認待ちの場合は、PR画面の **Approve workflows to run** から実行し、通常CIとmacOS実インストール検証を確認してからマージしてください（[GitHubのイベント起動仕様](https://docs.github.com/en/actions/how-tos/write-workflows/choose-when-workflows-run/trigger-a-workflow)）。

月次ジョブは取得したインストーラーを実行しません。インストールとシェル統合、再実行は隔離されたmacOSの実インストールCIで検証します。

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

一度リポジトリを配置したMacでは、次の手順で `master` の更新を取り込みます。

### 1. ブランチを最新状態にする

`master` に切り替えてから、リモートの最新状態をfast-forwardで取り込みます。

```bash
git -C ~/macos-infra switch master
git -C ~/macos-infra pull --ff-only origin master
```

`update.sh` 自身もpullしますが、実行中のスクリプトはpull前の内容のままです。先にpullしておくと、`update.sh` の変更も含めて最新の手順で更新できます。ローカルの変更やコミットがあってfast-forwardできない場合はpullが失敗するため、内容を確認してから対応してください。

### 2. 更新スクリプトを実行する

```bash
bash ~/macos-infra/update.sh
```

Brewfileに列挙されたツールも適用する場合は `--apply` を付けてください。

```bash
bash ~/macos-infra/update.sh --apply
```

Yarn Switchを導入・更新する場合は、続けて次を実行します（`update.sh` はYarn Switchを導入・更新しません）。

```bash
bash ~/macos-infra/shells/yarn-switch.sh
```

Safe Chainを導入・更新する場合は、続けて次を実行します（`update.sh` はSafe Chainを更新しません）。

```bash
bash ~/macos-infra/shells/safe-chain.sh
```

`update.sh` は未コミットの変更がある場合や `master` 以外のブランチでは停止します。dotfilesがリポジトリ内のファイルへシンボリックリンクされている場合、ファイル内容の変更は更新時に反映されます。新しいリンクの作成やRuby/Node.jsの変更、初期セットアップの再実行は行いません。

## リリース

GitHub Actionsの「GitHub Release」Workflowは、以下の2つの方法でリリースを作成できます。

- **タグで公開:** `master` の対象コミットに `1.0.0` 形式のタグを作成・pushする。
- **手動で公開:** GitHubの **Actions → GitHub Release → Run workflow** を開き、`master` を選び、`version` に `1.0.0` 形式を指定する。

どちらもGitHub Releaseを公開し、前回のリリースからマージされたPull RequestをGitHub標準の自動生成リリースノートに含めます。カテゴリは `.github/release.yml` のラベル設定に従います。タグ・リリースは一度公開した後に自動上書きしません。

手動実行は未使用タグを新規作成するため、**同じタグを事前にpushしないでください**。タグを先にpushした場合はタグのWorkflowが実行されます。実行前に通常CIと実インストールCIの成功を確認してください（リリースWorkflow自身はインストールテストを再実行しません）。

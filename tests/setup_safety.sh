#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

mkdir -p "$TMP_DIR/home/macos-infra" "$TMP_DIR/bin"
printf '既存データ\n' > "$TMP_DIR/home/macos-infra/sentinel"

cat > "$TMP_DIR/bin/xcode-select" <<'EOF'
#!/usr/bin/env bash
if [[ "${1:-}" == "-p" ]]; then
  exit 0
fi
exit 2
EOF
chmod +x "$TMP_DIR/bin/xcode-select"

# 既存の非Gitディレクトリを上書きせず、異常終了すること。
if HOME="$TMP_DIR/home" PATH="$TMP_DIR/bin:$PATH" bash "$ROOT/install.sh" >"$TMP_DIR/install.log" 2>&1; then
  echo "失敗: Git管理外の既存ディレクトリを検出できませんでした" >&2
  exit 1
fi
[[ "$(cat "$TMP_DIR/home/macos-infra/sentinel")" == "既存データ" ]]

# Gitの有無に関係なくCLT未導入なら案内して停止すること。
if HOME="$TMP_DIR/home" PATH="$TMP_DIR/bin:$PATH" bash "$ROOT/install.sh" >"$TMP_DIR/bootstrap.log" 2>&1; then
  echo "失敗: CLT未導入時にbootstrapが停止しませんでした" >&2
  exit 1
fi
grep -q "Xcode Command Line Toolsをインストールしてください" "$TMP_DIR/bootstrap.log"

cat > "$TMP_DIR/bin/xcode-select" <<'EOF'
#!/usr/bin/env bash
if [[ "${1:-}" == "-p" ]]; then
  exit 1
fi
if [[ "${1:-}" == "--install" ]]; then
  exit 0
fi
exit 2
EOF
chmod +x "$TMP_DIR/bin/xcode-select"

# Command Line Tools が未導入の場合、続く設定処理に進まないこと。
if PATH="$TMP_DIR/bin:$PATH" bash "$ROOT/shells/init.sh" >"$TMP_DIR/init.log" 2>&1; then
  echo "失敗: Command Line Tools 未導入でも処理が続行されました" >&2
  exit 1
fi
grep -q "Xcode Command Line Tools が見つかりません" "$TMP_DIR/init.log"
! grep -q "(2) dotfiles" "$TMP_DIR/init.log"

echo "セットアップの安全性テスト: 成功"

---
name: swiftlint
description: SwiftLintを実行してSwiftコードをチェック・修正する。"SwiftLintを実行"、"lintを実行"、"コードスタイルをチェック"、"lint errorを修正"、"--fixで修正"、"コードをフォーマット"などのリクエスト時に使用。バイナリパスと設定ファイルパスを自動で解決する。
context: fork
---

# SwiftLint

このプロジェクト用のSwiftLintラッパースキル。ios-devプラグインのswiftlintスキルに必要なパスを自動で渡す。

## パスの解決

以下のコマンドでSwiftLintのバイナリパスを取得:

```bash
readlink -f $(find BuildTools -type f -name "swiftlint" | grep "macos" | head -n 1)
```

設定ファイルはプロジェクトルートの `.swiftlint.yml` を使用。

## 使用方法

ios-devプラグインのswiftlintスキルのスクリプトを実行する。パスは上記コマンドで取得した値を使用。

```bash
# バイナリパスを取得
SWIFTLINT_PATH=$(readlink -f $(find BuildTools -type f -name "swiftlint" | grep "macos" | head -n 1))

# スクリプトを実行
python3 ${CLAUDE_PLUGIN_ROOT}/skills/swiftlint/scripts/swiftlint.py \
    --swiftlint-path "$SWIFTLINT_PATH" \
    --config-path .swiftlint.yml \
    [options]
```

### オプション

| パラメータ | 説明 | デフォルト |
|-----------|------|---------|
| `--path` | lint対象のパス（ファイルまたはディレクトリ） | カレントディレクトリ |
| `--fix` | 自動修正可能な違反を修正 | 無効 |
| `--format` | コードをフォーマット | 無効 |
| `--strict` | 警告をエラーとして扱う | 無効 |
| `--quiet` | エラーのみ出力 | 無効 |

### 例

lint実行:
```bash
SWIFTLINT_PATH=$(readlink -f $(find BuildTools -type f -name "swiftlint" | grep "macos" | head -n 1))
python3 ${CLAUDE_PLUGIN_ROOT}/skills/swiftlint/scripts/swiftlint.py \
    --swiftlint-path "$SWIFTLINT_PATH" \
    --config-path .swiftlint.yml \
    --path ./Sandbox-MultiModule-Library/Sources
```

自動修正:
```bash
SWIFTLINT_PATH=$(readlink -f $(find BuildTools -type f -name "swiftlint" | grep "macos" | head -n 1))
python3 ${CLAUDE_PLUGIN_ROOT}/skills/swiftlint/scripts/swiftlint.py \
    --swiftlint-path "$SWIFTLINT_PATH" \
    --config-path .swiftlint.yml \
    --path ./Sandbox-MultiModule-Library/Sources \
    --fix
```

修正とフォーマット:
```bash
SWIFTLINT_PATH=$(readlink -f $(find BuildTools -type f -name "swiftlint" | grep "macos" | head -n 1))
python3 ${CLAUDE_PLUGIN_ROOT}/skills/swiftlint/scripts/swiftlint.py \
    --swiftlint-path "$SWIFTLINT_PATH" \
    --config-path .swiftlint.yml \
    --path ./Sandbox-MultiModule-Library/Sources \
    --fix \
    --format
```

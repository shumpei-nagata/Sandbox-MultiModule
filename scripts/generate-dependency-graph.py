#!/usr/bin/env python3
"""
Swift Package Target依存関係グラフ生成スクリプト

swift package dump-packageのJSON出力を解析し、
subgraph付きMermaid形式のグラフを生成する
"""

from __future__ import annotations

import json
import subprocess
import sys
from collections import defaultdict
from pathlib import Path


def get_package_dir() -> Path:
    """スクリプトの場所からSandbox-MultiModule-Libraryのパスを取得"""
    script_dir = Path(__file__).resolve().parent
    return script_dir.parent / "Sandbox-MultiModule-Library"


def get_package_json(package_dir: Path) -> dict:
    """swift package dump-packageを実行してJSONを取得"""
    result = subprocess.run(
        ["swift", "package", "dump-package"],
        capture_output=True,
        text=True,
        check=True,
        cwd=package_dir
    )
    return json.loads(result.stdout)


def get_category_from_path(path: str) -> str | None:
    """pathからカテゴリを判定（Feature, Portのみグループ化）"""
    if path.startswith("Sources/Feature/"):
        return "Feature"
    elif path.startswith("Sources/Port/"):
        return "Port"
    else:
        return None


def extract_target_dependencies(target: dict) -> list[str]:
    """ターゲットの依存関係から内部ターゲット名のみを抽出"""
    dependencies = []
    for dep in target.get("dependencies", []):
        # byName形式: {"byName": ["TargetName", null]}
        if "byName" in dep:
            dep_name = dep["byName"][0]
            dependencies.append(dep_name)
        # target形式: {"target": ["TargetName", null]}
        elif "target" in dep:
            dep_name = dep["target"][0]
            dependencies.append(dep_name)
    return dependencies


def generate_mermaid(package: dict) -> str:
    """Mermaid形式のグラフを生成"""
    targets = package.get("targets", [])

    # カテゴリ別にターゲットを分類
    categories: dict[str, list[str]] = defaultdict(list)
    # ターゲット名のセット（内部ターゲット判定用）
    target_names: set[str] = set()
    # 依存関係のリスト
    edges: list[tuple[str, str]] = []

    for target in targets:
        name = target.get("name", "")
        path = target.get("path", "")
        target_names.add(name)

        category = get_category_from_path(path)
        if category:
            categories[category].append(name)

        # 依存関係を抽出
        for dep in extract_target_dependencies(target):
            edges.append((name, dep))

    # Mermaid出力を構築
    lines = ["graph TD"]

    # カテゴリの出力順序
    category_order = ["Port", "Feature"]

    for category in category_order:
        if categories[category]:
            lines.append(f"  subgraph {category}")
            for target in sorted(categories[category]):
                lines.append(f"    {target}")
            lines.append("  end")

    # 空行を追加
    lines.append("")

    # 依存関係を出力（内部ターゲットのみ）
    for source, target in sorted(edges):
        if target in target_names:
            lines.append(f"  {source} --> {target}")

    return "\n".join(lines)


def main():
    try:
        package_dir = get_package_dir()
        if not package_dir.exists():
            print(f"Error: Package directory not found: {package_dir}", file=sys.stderr)
            sys.exit(1)

        package = get_package_json(package_dir)
        mermaid = generate_mermaid(package)
        print(mermaid)
    except subprocess.CalledProcessError as e:
        print(f"Error running swift package dump-package: {e.stderr}", file=sys.stderr)
        sys.exit(1)
    except json.JSONDecodeError as e:
        print(f"Error parsing JSON: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()

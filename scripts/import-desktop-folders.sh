#!/usr/bin/env bash
# Copy the four Desktop folders into the life-template paths.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DESKTOP_DIR="${DESKTOP_DIR:-$HOME/Desktop}"
if [[ ! -d "$DESKTOP_DIR" && -d "$HOME/桌面" ]]; then
  DESKTOP_DIR="$HOME/桌面"
fi

declare -A MAP=(
  ["童童学习"]="孩子资料/童童学习"
  ["语言学习"]="自己学习/语言学习"
  ["赚钱"]="投资盯盘/赚钱"
  ["假死三年"]="写小说/假死三年"
)

if [[ ! -d "$DESKTOP_DIR" ]]; then
  echo "找不到桌面目录: $DESKTOP_DIR"
  echo "请设置 DESKTOP_DIR 后重试。"
  exit 1
fi

echo "源桌面: $DESKTOP_DIR"
echo "目标仓库: $ROOT"
echo

missing=0
for src_name in "童童学习" "语言学习" "赚钱" "假死三年"; do
  dest_rel="${MAP[$src_name]}"
  src="$DESKTOP_DIR/$src_name"
  dest="$ROOT/$dest_rel"
  mkdir -p "$dest"
  if [[ ! -e "$src" ]]; then
    echo "跳过（桌面没有）: $src_name"
    missing=$((missing + 1))
    continue
  fi
  echo "复制: $src_name  →  $dest_rel/"
  # Preserve contents; do not delete Desktop originals.
  if command -v rsync >/dev/null 2>&1; then
    rsync -a "$src"/ "$dest"/
  else
    cp -R "$src"/. "$dest"/
  fi
done

echo
if [[ "$missing" -eq 4 ]]; then
  echo "四个文件夹都没找到。请确认桌面路径，或手动拖进仓库后再说一声。"
  exit 2
fi

echo "完成。原桌面文件夹未删除。"
echo "可在 Cursor 里说：已放进仓库，请按模板继续整理。"

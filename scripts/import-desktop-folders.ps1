# Copy the four Desktop folders into the life-template paths (Windows).
$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$DesktopDir = if ($env:DESKTOP_DIR) { $env:DESKTOP_DIR } else { [Environment]::GetFolderPath("Desktop") }

$Map = [ordered]@{
  "童童学习" = "孩子资料\童童学习"
  "语言学习" = "自己学习\语言学习"
  "赚钱"     = "投资盯盘\赚钱"
  "假死三年" = "写小说\假死三年"
}

Write-Host "源桌面: $DesktopDir"
Write-Host "目标仓库: $Root"
Write-Host ""

if (-not (Test-Path -LiteralPath $DesktopDir)) {
  Write-Error "找不到桌面目录: $DesktopDir"
}

$missing = 0
foreach ($srcName in $Map.Keys) {
  $src = Join-Path $DesktopDir $srcName
  $dest = Join-Path $Root $Map[$srcName]
  New-Item -ItemType Directory -Force -Path $dest | Out-Null
  if (-not (Test-Path -LiteralPath $src)) {
    Write-Host "跳过（桌面没有）: $srcName"
    $missing++
    continue
  }
  Write-Host "复制: $srcName  →  $($Map[$srcName])\"
  Copy-Item -LiteralPath (Join-Path $src "*") -Destination $dest -Recurse -Force
}

Write-Host ""
if ($missing -eq 4) {
  Write-Error "四个文件夹都没找到。请确认桌面路径，或手动拖进仓库后再说一声。"
}

Write-Host "完成。原桌面文件夹未删除。"
Write-Host "可在 Cursor 里说：已放进仓库，请按模板继续整理。"

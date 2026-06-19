#!/bin/bash
# 앱 아이콘 생성: AppIconGen으로 1024 PNG를 굽고 → iconset → build/AppIcon.icns
# make-app-bundle.sh 가 이 스크립트를 호출해 번들에 넣는다. 단독 실행도 가능.
set -euo pipefail
cd "$(dirname "$0")/.."

OUT_PNG="build/AppIcon-1024.png"
ICONSET="build/AppIcon.iconset"
ICNS="build/AppIcon.icns"

swift build -c release --product AppIconGen
.build/release/AppIconGen "$OUT_PNG"

rm -rf "$ICONSET"
mkdir -p "$ICONSET"

# (파일명, 한 변 픽셀) — macOS iconset 규격
emit() { sips -z "$2" "$2" "$OUT_PNG" --out "$ICONSET/$1" >/dev/null; }
emit icon_16x16.png      16
emit icon_16x16@2x.png   32
emit icon_32x32.png      32
emit icon_32x32@2x.png   64
emit icon_128x128.png    128
emit icon_128x128@2x.png 256
emit icon_256x256.png    256
emit icon_256x256@2x.png 512
emit icon_512x512.png     512
emit icon_512x512@2x.png  1024

iconutil -c icns "$ICONSET" -o "$ICNS"
echo "OK: $ICNS"

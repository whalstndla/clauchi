#!/bin/bash
# release 빌드 → build/Clauchi.app 생성 + ad-hoc 서명
# 사용법: make-app-bundle.sh [version]   기본 0.1.0
set -euo pipefail
cd "$(dirname "$0")/.."
VERSION="${1:-0.1.0}"

swift package clean
swift build -c release
APP=build/Clauchi.app
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS"

cp .build/release/ClauchiApp "$APP/Contents/MacOS/Clauchi"
cp .build/release/ClauchiHook "$APP/Contents/MacOS/ClauchiHook"

# 앱 아이콘 생성 + 배치 (AppIconGen → iconset → AppIcon.icns)
bash Scripts/make-icon.sh
mkdir -p "$APP/Contents/Resources"
cp build/AppIcon.icns "$APP/Contents/Resources/AppIcon.icns"

cat > "$APP/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key><string>Clauchi</string>
    <key>CFBundleIdentifier</key><string>com.clauchi.app</string>
    <key>CFBundleName</key><string>Clauchi</string>
    <key>CFBundleIconFile</key><string>AppIcon</string>
    <key>CFBundlePackageType</key><string>APPL</string>
    <key>CFBundleShortVersionString</key><string>$VERSION</string>
    <key>LSMinimumSystemVersion</key><string>26.0</string>
    <key>LSUIElement</key><true/>
</dict>
</plist>
PLIST

codesign --force --deep --sign - "$APP"
echo "OK: $APP"

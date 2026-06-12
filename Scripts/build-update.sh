#!/bin/bash
# origin/main을 전용 worktree에서 증분 릴리스 빌드 → 스테이징 번들 생성.
# 사용자 워킹트리는 건드리지 않는다. 인자: $1 = 메인 레포 경로.
set -euo pipefail
REPO="$1"
WT="$HOME/.clauchi/update/worktree"
STAGING="$HOME/.clauchi/update/staging"

git -C "$REPO" fetch origin main

# 전용 worktree 보장 (없으면 생성, 있으면 origin/main으로 리셋)
if ! git -C "$REPO" worktree list --porcelain | grep -q "^worktree $WT$"; then
  rm -rf "$WT"
  git -C "$REPO" worktree add --force --detach "$WT" origin/main
fi
git -C "$WT" reset --hard origin/main

# 증분 릴리스 빌드 (swift package clean 없음)
swift build -c release --package-path "$WT"

APP="$STAGING/Clauchi.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS"
cp "$WT/.build/release/ClauchiApp" "$APP/Contents/MacOS/Clauchi"
cp "$WT/.build/release/ClauchiHook" "$APP/Contents/MacOS/ClauchiHook"

COMMIT=$(git -C "$WT" rev-parse HEAD)
cat > "$APP/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key><string>Clauchi</string>
    <key>CFBundleIdentifier</key><string>com.clauchi.app</string>
    <key>CFBundleName</key><string>Clauchi</string>
    <key>CFBundlePackageType</key><string>APPL</string>
    <key>CFBundleShortVersionString</key><string>0.1.0</string>
    <key>LSMinimumSystemVersion</key><string>26.0</string>
    <key>LSUIElement</key><true/>
    <key>ClauchiBuildCommit</key><string>$COMMIT</string>
</dict>
</plist>
PLIST

codesign --force --deep --sign - "$APP"
echo "STAGED:$COMMIT"

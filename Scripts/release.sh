#!/bin/bash
# 사용법: Scripts/release.sh <version>   예: Scripts/release.sh 0.2.0
# 해당 버전으로 번들 빌드 → ditto zip → GitHub 릴리스 발행.
set -euo pipefail
VERSION="$1"
cd "$(dirname "$0")/.."

Scripts/make-app-bundle.sh "$VERSION"

ZIP="build/Clauchi-v$VERSION.zip"
rm -f "$ZIP"
ditto -c -k --keepParent "build/Clauchi.app" "$ZIP"

gh release create "v$VERSION" "$ZIP" \
  --title "v$VERSION" \
  --notes "미서명 빌드. 첫 실행이 막히면: 우클릭→열기, 또는 터미널에서 \`xattr -dr com.apple.quarantine Clauchi.app\`"

echo "RELEASED: v$VERSION ($ZIP)"

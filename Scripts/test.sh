#!/bin/bash
# Command Line Tools 환경에서 Swift Testing 모듈 경로를 찾지 못하는 문제 우회.
# 사용법: Scripts/test.sh [--filter SomeTests]
set -euo pipefail
cd "$(dirname "$0")/.."
FRAMEWORKS=/Library/Developer/CommandLineTools/Library/Developer/Frameworks
exec swift test \
  -Xswiftc -F -Xswiftc "$FRAMEWORKS" \
  -Xlinker -F"$FRAMEWORKS" \
  -Xlinker -rpath -Xlinker "$FRAMEWORKS" \
  "$@"

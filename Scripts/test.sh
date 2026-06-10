#!/bin/bash
# Command Line Tools 환경에서 Swift Testing 모듈 경로를 찾지 못하는 문제 우회.
# 사용법: Scripts/test.sh [--filter SomeTests]
set -euo pipefail
cd "$(dirname "$0")/.."
FRAMEWORKS=/Library/Developer/CommandLineTools/Library/Developer/Frameworks
# -disable-cross-import-overlays: CLT에 _Testing_Foundation 인터페이스가 없어서
# Testing + Foundation 동시 임포트 시 빌드가 깨지는 문제 우회
exec swift test \
  -Xswiftc -F -Xswiftc "$FRAMEWORKS" \
  -Xswiftc -Xfrontend -Xswiftc -disable-cross-import-overlays \
  -Xlinker -F"$FRAMEWORKS" \
  -Xlinker -rpath -Xlinker "$FRAMEWORKS" \
  "$@"

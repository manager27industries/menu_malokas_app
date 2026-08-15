#!/usr/bin/env bash
set -euo pipefail

if ! command -v flutter >/dev/null 2>&1; then
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$HOME/flutter-sdk"
  export PATH="$HOME/flutter-sdk/bin:$PATH"
fi

flutter config --no-analytics --enable-web
flutter pub get
flutter build web --release

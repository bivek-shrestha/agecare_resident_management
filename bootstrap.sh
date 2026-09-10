#!/usr/bin/env bash
set -e
flutter create . --platforms=android,ios,web
flutter pub get
echo "AgeCare is ready. Run: flutter run"

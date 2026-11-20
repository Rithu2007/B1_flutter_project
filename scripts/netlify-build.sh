#!/usr/bin/env bash
# Installs the Flutter SDK (cached between Netlify builds) and builds the web app.
set -euo pipefail

FLUTTER_VERSION="${FLUTTER_VERSION:-3.50.1}"
CACHE_ROOT="${NETLIFY_CACHE_DIR:-$HOME/.cache}"
FLUTTER_ROOT_DIR="${CACHE_ROOT}/flutter-sdk-${FLUTTER_VERSION}"
FLUTTER_HOME="${FLUTTER_ROOT_DIR}/flutter"
ARCHIVE_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"

if [ ! -x "$FLUTTER_HOME/bin/flutter" ]; then
  echo "Installing Flutter ${FLUTTER_VERSION} from release archive..."
  rm -rf "$FLUTTER_ROOT_DIR"
  mkdir -p "$FLUTTER_ROOT_DIR"
  curl -fsSL "$ARCHIVE_URL" | tar -xJ -C "$FLUTTER_ROOT_DIR"
fi

export PATH="$FLUTTER_HOME/bin:$PATH"
export CI=true
export FLUTTER_SUPPRESS_ANALYTICS=true

# First run downloads the Dart SDK and writes the version metadata file.
flutter --version >/dev/null 2>&1 || true

# Some build environments block git commands the Flutter tool uses to detect
# its own version, leaving it as "0.0.0-unknown" (which breaks `pub get`).
# Pin the metadata to the known release version in that case.
VERSION_FILE="$FLUTTER_HOME/bin/cache/flutter.version.json"
if [ -f "$VERSION_FILE" ]; then
  node -e '
    const fs = require("fs");
    const [file, version] = process.argv.slice(1);
    const d = JSON.parse(fs.readFileSync(file, "utf8"));
    if (d.frameworkVersion !== version) {
      Object.assign(d, {
        frameworkVersion: version,
        flutterVersion: version,
        channel: "stable",
        repositoryUrl: "https://github.com/flutter/flutter.git",
        frameworkRevision: d.engineRevision || "unknown",
        frameworkCommitDate: d.engineCommitDate || "1970-01-01 00:00:00.000",
      });
      fs.writeFileSync(file, JSON.stringify(d, null, 2));
      console.log("Pinned Flutter version metadata to " + version);
    }
  ' "$VERSION_FILE" "$FLUTTER_VERSION"
fi

flutter config --no-analytics >/dev/null 2>&1 || true
flutter --version
flutter pub get
flutter build web --release

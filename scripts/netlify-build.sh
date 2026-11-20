#!/usr/bin/env bash
# Downloads the Flutter SDK release archive (cached between builds) and builds the web app.
# Uses the official release tarball instead of `git clone`, and pins the SDK version
# metadata so Flutter does not need git to detect its own version.
set -euo pipefail

BASE_URL="https://storage.googleapis.com/flutter_infra_release/releases"
CACHE_ROOT="${NETLIFY_CACHE_DIR:-$HOME/.cache}"
mkdir -p "$CACHE_ROOT"

# Resolve the current stable release metadata (archive path, version, commit hash, date)
RELEASE_JSON="$(curl -fsSL "$BASE_URL/releases_linux.json" | node -e '
let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{
  const j=JSON.parse(s);const h=j.current_release.stable;
  process.stdout.write(JSON.stringify(j.releases.find(r=>r.hash===h)));
})')"
ARCHIVE="$(node -e 'process.stdout.write(JSON.parse(process.argv[1]).archive)' "$RELEASE_JSON")"
VERSION_TAG="$(basename "$ARCHIVE" .tar.xz)"
FLUTTER_HOME="$CACHE_ROOT/$VERSION_TAG"
FLUTTER_ROOT_DIR="$FLUTTER_HOME/flutter"

if [ ! -x "$FLUTTER_ROOT_DIR/bin/flutter" ]; then
  echo "Downloading Flutter: $ARCHIVE"
  rm -rf "$FLUTTER_HOME" && mkdir -p "$FLUTTER_HOME"
  curl -fsSL "$BASE_URL/$ARCHIVE" | tar -xJ -C "$FLUTTER_HOME"
fi

export PATH="$FLUTTER_ROOT_DIR/bin:$PATH"

# First run bootstraps the Dart SDK and the flutter tool (this regenerates the version file).
flutter config --no-analytics --enable-web >/dev/null

# Write the real release version into bin/cache/flutter.version.json so the tool
# trusts it instead of falling back to git (which is restricted here) and reporting 0.0.0-unknown.
VERSION_FILE="$FLUTTER_ROOT_DIR/bin/cache/flutter.version.json"
node -e '
const fs=require("fs");const path=require("path");
const [file,releaseJson,root]=process.argv.slice(1);
const rel=JSON.parse(releaseJson);
let m={};try{m=JSON.parse(fs.readFileSync(file,"utf8"))}catch{}
const read=(p)=>{try{return fs.readFileSync(path.join(root,p),"utf8").trim()}catch{return ""}};
let devtools=m.devToolsVersion;
if(!devtools||devtools==="0.0.0-unknown"){try{devtools=JSON.parse(read("bin/cache/dart-sdk/bin/resources/devtools/version.json")).version}catch{devtools="0.0.0"}}
const date=new Date(rel.release_date).toISOString().replace("T"," ").replace(/\.\d+Z$/," +0000");
Object.assign(m,{
  frameworkVersion: rel.version,
  channel: rel.channel,
  repositoryUrl: "https://github.com/flutter/flutter.git",
  frameworkRevision: rel.hash,
  frameworkCommitDate: date,
  engineRevision: (m.engineRevision && !/[^0-9a-f]/.test(m.engineRevision)) ? m.engineRevision : (read("bin/internal/engine.version") || rel.hash),
  dartSdkVersion: rel.dart_sdk_version,
  devToolsVersion: devtools,
  flutterVersion: rel.version,
});
fs.writeFileSync(file, JSON.stringify(m,null,2));
' "$VERSION_FILE" "$RELEASE_JSON" "$FLUTTER_ROOT_DIR"

flutter --version
flutter pub get
flutter build web --release

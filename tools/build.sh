#!/usr/bin/env bash
# Builds DuckStation-FS.apk and the xdelta patch from a stock DuckStation Android 12010 APK.
# Needs: apktool, python3, keytool (JDK), apksigner, xdelta3.   Termux: pkg install apktool python openjdk-17 apksigner xdelta3
# Usage: tools/build.sh /path/to/stock-duckstation-12010.apk
set -euo pipefail

STOCK_SHA256=896e6549a86c4c95f1919b6196915b4235f25049e6e8dd9afdf2fbb269654be6
STOCK=${1:?usage: tools/build.sh stock-duckstation-12010.apk}
ROOT=$(cd "$(dirname "$0")/.." && pwd)
WORK=$ROOT/build
APKTOOL=${APKTOOL:-apktool}

got=$(sha256sum "$STOCK" | cut -d' ' -f1)
[ "$got" = "$STOCK_SHA256" ] || { echo "stock APK sha256 is $got, expected $STOCK_SHA256" >&2; exit 1; }

rm -rf "$WORK" && mkdir -p "$WORK"
echo "== decode stock APK"
$APKTOOL d -f "$STOCK" -o "$WORK/dec" >/dev/null

echo "== swap in the patch sources"
rm -rf "$WORK"/dec/smali "$WORK"/dec/smali_classes* "$WORK"/dec/build
mkdir -p "$WORK/dec/smali"
cp -r "$ROOT/src/smali/." "$WORK/dec/smali/"
python3 "$ROOT/tools/edit_manifest.py" "$WORK/dec/AndroidManifest.xml"

echo "== build manifest + patch dex"
$APKTOOL b -f "$WORK/dec" -o "$WORK/mini.apk" >/dev/null
python3 - "$WORK" <<'PY'
import sys, zipfile
w = sys.argv[1]
z = zipfile.ZipFile(w + "/mini.apk")
open(w + "/AndroidManifest.bin", "wb").write(z.read("AndroidManifest.xml"))
open(w + "/classes3.bin", "wb").write(z.read("classes.dex"))
PY

echo "== assemble APK (manifest, patch dex, library NOP)"
python3 "$ROOT/tools/build_fs_raw.py" "$STOCK" "$WORK/AndroidManifest.bin" "$WORK/classes3.bin" "$WORK/unsigned.apk"

echo "== sign"
KS=$WORK/debug.keystore
keytool -genkeypair -keystore "$KS" -storepass android -keypass android -alias androiddebugkey \
  -keyalg RSA -keysize 2048 -validity 10000 -dname "CN=Android Debug,O=Android,C=US" >/dev/null 2>&1
apksigner sign --ks "$KS" --ks-pass pass:android --ks-key-alias androiddebugkey --key-pass pass:android \
  --out "$ROOT/DuckStation-FS.apk" "$WORK/unsigned.apk"

echo "== delta"
if command -v xdelta3 >/dev/null; then
  xdelta3 -e -9 -f -s "$STOCK" "$ROOT/DuckStation-FS.apk" "$ROOT/patch/duckstation-12010-to-FS.xdelta"
fi
sha256sum "$ROOT/DuckStation-FS.apk"
echo "done: $ROOT/DuckStation-FS.apk"

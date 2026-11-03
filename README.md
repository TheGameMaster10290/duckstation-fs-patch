# DuckStation FS

A patch for the **stock DuckStation Android 12010 APK** that lets game frontends and launchers start
games by passing a file URI, the way they do for other emulators.

No DuckStation code or APK is included. You supply your own stock APK; this repo contains a binary
delta and the sources that produce it.

## What it changes

- **Launcher label** is "DuckStation FS".
- **Boot path fix.** Many frontends pass the game as a `content://` URI string in the `bootPath` extra
  (or as intent data). DuckStation's native layer can only open filesystem paths and fails with
  `Failed to open CD image … errno 2`. A small provider (`FrontendInit`) registers an activity callback
  (`FrontendCb`) that runs just before `EmulationActivity` starts and rewrites the path (`FrontendPath`):
  - `content://com.android.externalstorage.documents/...` becomes `/storage/<volume>/<path>`
  - `file://...` becomes a plain path
  - if the file isn't directly readable it falls back to DuckStation's own `FileHelper.uriToPseudoPath`
  - plain paths pass through unchanged
  - with no `bootPath` extra, the intent's data URI is used
- **Manifest:** all-files access, VIEW/LAUNCH intent filters on `EmulationActivity`
  (see [`src/manifest-changes.md`](src/manifest-changes.md)).
- **Signing check disabled** (4 bytes in `libduckstation.so`, see [`src/native-patch.md`](src/native-patch.md)).
  Required: a re-signed APK otherwise skips core init and crashes on game start.

## Apply the patch (Termux)

Requires the stock DuckStation Android **12010** APK, sha256
`896e6549a86c4c95f1919b6196915b4235f25049e6e8dd9afdf2fbb269654be6`.

```sh
pkg install xdelta3
xdelta3 -d -s duckstation-12010.apk patch/duckstation-12010-to-FS.xdelta DuckStation-FS.apk
sha256sum DuckStation-FS.apk   # a60d25b3ba25955efad9f76d05e4d2834cc4cd6d097c3415453dcd39f64ae9af
```

The output is already signed (Android debug certificate) and zipaligned. Install it, then enable
**All files access** for DuckStation FS in Android's special app access settings. The package name is
unchanged (`com.github.stenzek.duckstation`), so uninstall the stock app first if Android reports a
signature mismatch.

## Using it from a frontend

Any frontend that can launch an activity with extras works. The component is
`com.github.stenzek.duckstation/.EmulationActivity`. Either form is accepted:

```sh
# bootPath extra: plain path, file:// or content:// URI
am start -n com.github.stenzek.duckstation/.EmulationActivity --es bootPath "/storage/XXXX-XXXX/ROMs/psx/Game.chd"

# VIEW intent with the game as data
am start -a android.intent.action.VIEW -n com.github.stenzek.duckstation/.EmulationActivity -d "file:///storage/XXXX-XXXX/ROMs/psx/Game.chd"
```

## Build from source

```sh
pkg install apktool python openjdk-17 apksigner xdelta3
bash tools/build.sh /path/to/duckstation-12010.apk
```

This decodes your stock APK locally, swaps in `src/smali`, applies `tools/edit_manifest.py`, rebuilds,
signs with a freshly generated debug key, and writes `DuckStation-FS.apk` plus a new delta. Builds signed
with a different key than the released delta have a different hash and cannot be installed over it
without uninstalling first.

## Layout

```
patch/duckstation-12010-to-FS.xdelta   released binary delta
src/smali/                             FrontendInit, FrontendCb, FrontendPath
src/manifest-changes.md                what the manifest edit adds
src/native-patch.md                    the library byte patch
tools/build.sh                         stock APK -> patched APK + delta
tools/edit_manifest.py                 manifest edits
tools/build_fs_raw.py                  APK assembler (keeps stock compressed data, aligns .so to 16 KB)
```

## Notice

Not affiliated with or endorsed by the DuckStation project. DuckStation is a separate project with its
own license, which applies to the APK you supply. Check it before redistributing anything derived from
it. This repo distributes only the delta and original sources, never the APK.

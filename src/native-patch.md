# Native patch: signing-certificate check

DuckStation's `libduckstation.so` (arm64-v8a) hashes the APK's signing certificate (SHA-256)
and compares it with an obfuscated constant. On a mismatch it skips core initialisation, so the
first emulation command dereferences a null command FIFO and the app crashes when a game boots.
A re-signed APK therefore cannot run games unless the check is disabled.

| | |
|---|---|
| File | `lib/arm64-v8a/libduckstation.so` (stock 12010) |
| File offset (= vaddr) | `0x1b7868` |
| Stock bytes | `f6 5b 07 36` |
| Patched bytes | `1f 20 03 d5` (`nop`) |

`tools/build_fs_raw.py` verifies the stock bytes before writing, and refuses to patch otherwise.
Only the arm64-v8a library is changed.

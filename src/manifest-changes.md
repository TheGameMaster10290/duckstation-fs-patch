# Manifest changes (added or changed only)

Applied by `tools/edit_manifest.py` to the decoded stock manifest.

- Permissions: `MANAGE_EXTERNAL_STORAGE`, `READ_EXTERNAL_STORAGE`,
  `WRITE_EXTERNAL_STORAGE` (maxSdkVersion 29).
- Label: `android:label="DuckStation FS"` on `<application>` and `EmulationActivity`.
- `EmulationActivity`: three intent filters
  - VIEW + `com.github.stenzek.duckstation.LAUNCH`, DEFAULT + BROWSABLE, data schemes `file` and `content`
  - the same without BROWSABLE, plus `mimeType */*`
  - `com.github.stenzek.duckstation.LAUNCH` only
- Provider `com.github.stenzek.duckstation.FrontendInit`, authority
  `com.github.stenzek.duckstation.frontend-init`, not exported, `initOrder=100`.

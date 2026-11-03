DuckStation FS (Frontend Support) is a patch for the stock DuckStation Android 12010 APK that lets game frontends launch games by passing content:// or file:// paths, and you supply your own APK and apply the xdelta in patch/ (steps below). 

Disclaimer: this was made with AI for my own personal use, so I'm not going to be supporting it or fixing minor bugs. It's not affiliated with the DuckStation project, and no DuckStation code or APK is included.

Resume: when a frontend launches a game, the newest save state for that game is loaded automatically, whether it is a numbered slot, a global slot or the auto-resume state written by "Save State On Exit". A state counts for the game when its header's game path matches the launched path, or has the same file name if the path differs. To boot fresh from a frontend, add the extra `--ez fsBootFresh true`; a launcher that passes its own `saveStatePath` extra is left alone. If no state is found, a toast says so, and every frontend launch writes what it found to `frontend-launch.txt` in DuckStation's data folder.

Signing: `tools/build.sh` keeps its key in `fs-debug.keystore` (gitignored) so rebuilds install over the previous build. Back that file up; a different key means uninstalling first, which deletes DuckStation's data under Android/data.

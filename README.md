# FRINKELs

FRINKELs is a private messenger for Android. This repository is a full, exact clone of [Signal Android](https://github.com/signalapp/Signal-Android) (upstream **8.26.2**), rebranded as **FRINKELs**.

Same protocol. Same end-to-end encryption. FRINKELs name, icon, and user-facing copy.

Send high-fidelity messages, join HD voice and video calls, and keep conversations private. Encryption is always on.

## What changed from upstream

| Area | FRINKELs |
| --- | --- |
| App name | `FRINKELs` |
| Application ID | `org.frinkels.messenger` |
| Launcher icon | Gold **F** on a deep teal field |
| User-facing strings | "Signal" → "FRINKELs" |
| Gradle project | `FRINKELs` / `FRINKELs-Android` |
| Kotlin/Java packages | Unchanged (`org.thoughtcrime.securesms`) so the client stays build-compatible with upstream |
| Wire protocol / service URLs | Unchanged from Signal Android 8.26.2 |

Internal package names, libsignal, and AGPL copyright headers for Signal Messenger, LLC are intentionally left intact.

## Build

Requirements match upstream Signal Android: a current Android Studio / JDK toolchain, plus the NDK and CMake versions pinned in `reproducible-builds/Dockerfile`.

```bash
./gradlew assemblePlayProdDebug
```

Other useful variants:

```bash
./gradlew assemblePlayProdRelease
./gradlew assembleWebsiteProdRelease
./gradlew assembleGithubProdRelease
```

Open the project root in Android Studio and sync Gradle if you prefer the IDE.

The debug APK installs as **FRINKELs** (`org.frinkels.messenger`) and can sit next to official Signal on the same device.

## Project layout

This is the upstream Signal Android tree:

- `app/` — main Android application
- `lib/` — shared libraries (including libsignal-service)
- `feature/` — feature modules (registration, camera, settings, media)
- `core/` — models, UI, networking, utilities
- `reproducible-builds/` — Docker image for bit-for-bit APKs

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Bug reports belong in this repo's issue tracker.

## Legal

This distribution includes cryptographic software. The country in which you currently reside may have restrictions on the import, possession, use, and/or re-export to another country of encryption software. Before using any encryption software, check your country's laws, regulations, and policies. See <http://www.wassenaar.org/> for more information.

The U.S. Government Department of Commerce, Bureau of Industry and Security (BIS), has classified this software as Export Commodity Control Number (ECCN) 5D002.C.1, which includes information security software using or performing cryptographic functions with asymmetric algorithms. The form and manner of this distribution makes it eligible for export under the License Exception ENC Technology Software Unrestricted (TSU) exception (see the BIS Export Administration Regulations, Section 740.13) for both object code and source code.

### License

Copyright 2013 Signal Messenger, LLC

FRINKELs is a rebranded fork of Signal Android.

Licensed under the GNU AGPLv3: https://www.gnu.org/licenses/agpl-3.0.html

Google Play and the Google Play logo are trademarks of Google LLC.
Signal is a trademark of Signal Messenger, LLC.

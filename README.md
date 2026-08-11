# signings

Dummy repo that builds unsigned binaries via GitHub Actions, for local
code-signing experiments.

## Windows exe

- `src/DummyApp` is a minimal .NET 8 console app.
- `.github/workflows/build.yml` builds a self-contained, single-file
  `DummyApp.exe` on a Windows runner, verifies it is a real PE binary by
  checking the `MZ` magic bytes and executing it, then uploads it as the
  `DummyApp` artifact. Sign it locally with `signtool` or `osslsigncode`.

## Android apk

- `android/` is a minimal Android app (no dependencies, one Activity).
- `.github/workflows/build-apk.yml` builds an unsigned release APK on an
  Ubuntu runner, verifies it contains `AndroidManifest.xml` and
  `classes.dex`, then uploads it as the `DummyApp-apk` artifact.
- Sign it locally with the Android SDK build tools:

  ```bash
  keytool -genkeypair -keystore test.jks -alias test -keyalg RSA -validity 365
  zipalign -p 4 app-release-unsigned.apk app-aligned.apk
  apksigner sign --ks test.jks --out app-signed.apk app-aligned.apk
  apksigner verify --verbose app-signed.apk
  ```

## iOS ipa

- `ios/` is a minimal SwiftUI app; the Xcode project is generated in CI with
  [xcodegen](https://github.com/yonaskolb/XcodeGen) from `ios/project.yml`.
- `.github/workflows/build-ipa.yml` builds the app **unsigned** on a macOS
  runner (`CODE_SIGNING_ALLOWED=NO`), packages it into
  `DummyApp-unsigned.ipa` (a zip with a `Payload/` folder), verifies the main
  binary is a real Mach-O executable, then uploads it as the `DummyApp-ipa`
  artifact.
- Unlike the exe/apk, signing an ipa that installs on a device requires an
  Apple-issued certificate and a provisioning profile — a self-signed cert is
  not enough. Sign locally with `codesign` + your provisioning profile,
  `fastlane resign`, or `zsign`.

## Getting the artifacts

Each workflow runs on pushes to `main` touching its files, or manually via
the **Run workflow** button. Open the **Actions** tab, pick the latest run,
and download the artifact from the run page.

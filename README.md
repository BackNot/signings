# signings

Dummy repo that builds a valid Windows `.exe` via GitHub Actions, for local
code-signing experiments.

## How it works

- `src/DummyApp` is a minimal .NET 8 console app.
- `.github/workflows/build.yml` runs on every push to `main` (or manually via
  the **Run workflow** button). It builds a self-contained, single-file
  `DummyApp.exe` on a Windows runner, verifies it is a real PE binary by
  checking the `MZ` magic bytes and executing it, then uploads it as a build
  artifact.

## Getting the exe

1. Push this repo to GitHub.
2. Open the **Actions** tab, pick the latest "Build dummy exe" run.
3. Download the `DummyApp` artifact — it contains `DummyApp.exe`, unsigned and
   ready for signing (e.g. with `signtool` or `osslsigncode`).

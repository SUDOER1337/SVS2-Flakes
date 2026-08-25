# Known Issues

## Current

- **Compatibility Matrix Empty** — Testing has not yet been completed.
  Wine version recommendations will be added once testing is done.
- **WebView2 Not Installed** — SynthV may require WebView2 for the login
  dialog. Installation will be automated in a future phase.
- **dotnet Not Installed** — .NET Framework may be needed. Will be
  automated alongside WebView2.
- **No URI Handler** — `synthv://` protocol registration for
  browser-based authentication is not yet implemented.

## Mitigations

Until WebView2 and dotnet are automated:

1. Install dotnet45 via Winetricks:
   ```bash
   winetricks dotnet45
   ```
2. Install WebView2 manually by downloading the evergreen bootstrapper
   and running it in the prefix.

## Upstream

- SynthV is not tested against all Wine versions.
- Wine's implementation of WebView2 is partial.

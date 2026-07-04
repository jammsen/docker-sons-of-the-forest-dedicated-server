# Changelog

[Back to main](README.md#changelog)

## 2026-07-04

- Updating and fixing bugs regarding Debian Trixie and Wine 11 @jammsen (#82)
- Fixed server start after base-image switch to Debian 13 (trixie): base image un-pinned from `root-bookworm` back to `root`, WineHQ repo now uses trixie packages
- Fixed server launch with Wine 11 (`wine64` binary was removed, now uses `wine`)
- Fixed Healthcheck and graceful shutdown: Wine 11 reports the game process as `MainThrd`, matching now via full command line (`pgrep -f`)
- Removed obsolete `software-properties-common` from the build
- Fixed steam_appid.txt existence check in the servermanager (checked the game directory instead of the file)
- Installing gosu from the Debian package repository instead of shipping a binary in the repo, including unit-tests @jammsen (#83)
- Extended the log-noise filter with Unity JobTempAlloc "leak" spam, deprecation messages, asset-GC housekeeping and blank lines; WINEDEBUG=-all now also applies to wineboot
- Renamed docker-compose.yml to compose.yml following the current Docker Compose specification @jammsen
- Updated .gitignore for the new compose file naming, local override files (compose-*.yml, custom.env), .vscode/ and test/ @jammsen
- Updated README: compose.yml naming, removed the deprecated version field from the example, base-image now named as Debian Trixie @jammsen
- Changed the info log color from bright blue to a theme-independent light blue (256-color) for better readability on dark terminals
- Added SteamCMD self-healing: on failure the servermanager clears SteamCMD's self-update state and retries up to 3 times, fixing the misleading "Steamcmd needs to be online to update" crash-loop caused by corrupt update state persisting in the container
- Adopted best practices from the Palworld image: base image is now digest-pinned (prevents silent base-image changes like the trixie switch), added build-time smoke tests for gosu and wine, added .dockerignore to keep game files out of the docker build context

## 2025-03-29

- Added FILTER_SHADER_AND_MESH_AND_WINE_DEBUG environment variable to filter out shader and mesh-related warning/error messages and Wine debug-logs from the logs @jammsen (#72)

## 2025-01-26

- Added Healthcheck @jammsen (#69)
- Added Changelog
- Updated Readme with a "table of contents", changelog and updated points from ideas of the Palworld Readme
- Added Feature Request template
- Updated Bug Report template
- Added CI/CD unit-test, thanks to @thijsvanloef for letting me use the base

[Back to main](README.md#changelog)
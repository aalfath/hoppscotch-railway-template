# Changelog

## 2026.10.1-railway.1 (2026-11-16)

- The Railway template now builds from this repository instead of running the images directly, so deployers get Railway's "update available" notice when `main` changes.
- Hoppscotch 2026.10.1 (`hoppscotch/hoppscotch@sha256:09a50aa1…`) and Mailpit v1.33.1 (`axllent/mailpit@sha256:aef2aacc…`), unchanged from the image-based template.
- The start script moved from an inline base64 start command into `hoppscotch/railway-start.sh`; its behaviour is unchanged (migrations, first-boot admin and e-mail sign-in, restart after Hoppscotch's planned exits).
- No breaking changes.

# Changelog

## 2026.10.1-railway.2 (2026-11-19): Mailpit v1.34.0 (security release)

- No breaking changes for this template. Mailpit v1.34.0 removes flags deprecated for over two years and refuses some invalid settings at start; this template uses none of them (it sets `--listen`, `--smtp`, `--database` and `MP_UI_AUTH`). Messages on the Mailpit `/data` volume and all Hoppscotch data in Postgres are kept. Hoppscotch itself is unchanged (2026.10.1).
- Mailpit [v1.34.0](https://github.com/axllent/mailpit/releases/tag/v1.34.0) fixes [GHSA-v887-64wg-qqc9](https://github.com/axllent/mailpit/security/advisories/GHSA-v887-64wg-qqc9): a crafted message could crash Mailpit's SMTP server. It also adds limits on memory and CPU use while parsing messages.
- Image: `axllent/mailpit:v1.34.0@sha256:23a2ef85bc50853ab3093645d1d64679afd8887e89da5e48a88940c172591a4e`.

## 2026.10.1-railway.1 (2026-11-16)

- The Railway template now builds from this repository instead of running the images directly, so deployers get Railway's "update available" notice when `main` changes.
- Hoppscotch 2026.10.1 (`hoppscotch/hoppscotch@sha256:09a50aa1…`) and Mailpit v1.33.1 (`axllent/mailpit@sha256:aef2aacc…`), unchanged from the image-based template.
- The start script moved from an inline base64 start command into `hoppscotch/railway-start.sh`; its behaviour is unchanged (migrations, first-boot admin and e-mail sign-in, restart after Hoppscotch's planned exits).
- No breaking changes.

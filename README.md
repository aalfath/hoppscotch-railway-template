[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/hoppscotch-1?utm_medium=integration&utm_source=button&utm_campaign=hoppscotch)

# Hoppscotch on Railway

This repository is the source of the [Hoppscotch Railway template](https://railway.com/deploy/hoppscotch-1). It deploys [Hoppscotch](https://hoppscotch.io) Community Edition **2026.10.1**, the open-source API client for REST, GraphQL, WebSocket, SSE, Socket.IO and MQTT, with PostgreSQL and a small Mailpit inbox for e-mail sign-in.

## What the template deploys

| Service | Source | Purpose |
|---|---|---|
| Hoppscotch | [`hoppscotch/`](hoppscotch/Dockerfile): `hoppscotch/hoppscotch:2026.10.1` (pinned by digest) | Web app on `/`, admin dashboard on `/admin`, API on `/backend`, all on one Railway domain (port 80) |
| Mailpit | [`mailpit/`](mailpit/Dockerfile): `axllent/mailpit:v1.33.1` (pinned by digest) | Receives the sign-in links (SMTP on 1025, private network); password-protected web inbox on its own domain |
| Postgres | Railway PostgreSQL | Users, collections, teams and settings |

`hoppscotch/railway-start.sh` applies the database migrations, then, on the first boot only, turns on e-mail sign-in through Mailpit and creates `ADMIN_EMAIL` as the administrator, so nobody else can claim a fresh URL through Hoppscotch's open onboarding page. Hoppscotch exits on purpose after its first-boot setup and after every settings change in the admin dashboard; the script starts it again within a few seconds.

## Variables

| Service | Variable | Default | Notes |
|---|---|---|---|
| Hoppscotch | `ADMIN_EMAIL` | (you enter it) | The only prompt. Becomes the administrator and the only account that can sign in at first |
| Hoppscotch | `DATA_ENCRYPTION_KEY` | `${{secret(32)}}` | Encrypts stored secrets; keep it once set |
| Hoppscotch | `DATABASE_URL` | `${{Postgres.DATABASE_URL}}` | |
| Hoppscotch | `SMTP_HOST`, `SMTP_PORT` | `${{Mailpit.RAILWAY_PRIVATE_DOMAIN}}`, `1025` | Used only on the first boot; change mail later in `/admin` |
| Hoppscotch | `MAIL_FROM` | `Hoppscotch <hoppscotch@YOUR-DOMAIN>` | Sender of the sign-in mails |
| Hoppscotch | `VITE_*`, `WHITELISTED_ORIGINS` | built from `RAILWAY_PUBLIC_DOMAIN` | Replace the domain here if you add a custom one |
| Mailpit | `MAILPIT_USERNAME`, `MAILPIT_PASSWORD` | `admin`, a generated secret | Log-in for the Mailpit inbox |

## First sign-in

1. Open the Hoppscotch URL and sign in with your `ADMIN_EMAIL`.
2. Open the Mailpit URL, log in with `MAILPIT_USERNAME` and `MAILPIT_PASSWORD` (Mailpit service, Variables tab), and click the link in the "Sign in to Hoppscotch" mail.
3. The admin dashboard is at `https://YOUR-DOMAIN/admin`. Add a real SMTP server or an OAuth provider there to let your team in; after that you can remove the Mailpit service.

## How updates reach you

Railway builds each service from this repository's `main` branch. When a change is merged to `main` (a new Hoppscotch release, for example), Railway shows an "update available" notice in your project, and you choose when to apply it. Read [CHANGELOG.md](CHANGELOG.md) before you update. Hoppscotch applies its own database migrations on start.

## Local test

```sh
docker build -t hoppscotch-railway ./hoppscotch
docker build -t mailpit-railway ./mailpit
```

Run them with a PostgreSQL database and the variables above (`DATABASE_URL`, `DATA_ENCRYPTION_KEY`, `ADMIN_EMAIL`, `SMTP_HOST`, the `VITE_*` URLs pointing at `http://localhost:PORT`).

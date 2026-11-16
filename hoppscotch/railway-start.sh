#!/bin/sh
# Hoppscotch on Railway: migrate, seed the first boot, then start the all-in-one image.
set -e
cd /dist/backend
# One Railway domain serves the app (/), the admin dashboard (/admin) and the API (/backend).
# Caddy listens on :80; the backend must stay on 8080, where Caddy proxies /backend.
export PORT=8080 ENABLE_SUBPATH_BASED_ACCESS="${ENABLE_SUBPATH_BASED_ACCESS:-true}" TRUST_PROXY="${TRUST_PROXY:-true}"
log() { echo "[railway-start] $*"; }
log "applying database migrations"
npx prisma migrate deploy
# First boot only (no users yet): finish onboarding with e-mail sign-in through the
# bundled Mailpit SMTP server and create ADMIN_EMAIL as the admin, so nobody else can
# claim a fresh URL through the open onboarding endpoint. Later boots change nothing;
# edit mail and sign-in settings in the admin dashboard (/admin).
node <<'JS'
const { Client } = require("pg");
(async () => {
  const db = new Client({ connectionString: process.env.DATABASE_URL });
  await db.connect();
  const users = (await db.query('SELECT count(*)::int AS n FROM "User"')).rows[0].n;
  if (users > 0) { console.log("[railway-start] users exist, first-boot setup skipped"); return db.end(); }
  const email = (process.env.ADMIN_EMAIL || "").trim();
  if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)) { console.error("[railway-start] set ADMIN_EMAIL to a valid e-mail address"); process.exit(1); }
  const cfg = {
    VITE_ALLOWED_AUTH_PROVIDERS: "EMAIL",
    MAILER_SMTP_ENABLE: "true",
    MAILER_USE_CUSTOM_CONFIGS: "true",
    MAILER_SMTP_HOST: process.env.SMTP_HOST,
    MAILER_SMTP_PORT: process.env.SMTP_PORT || "1025",
    MAILER_SMTP_SECURE: "false",
    MAILER_SMTP_IGNORE_TLS: "true",
    MAILER_TLS_REJECT_UNAUTHORIZED: "false",
    MAILER_ADDRESS_FROM: /@[^@\s<>]+\.[^@\s<>]+>?$/.test(process.env.MAIL_FROM || "") ? process.env.MAIL_FROM : "Hoppscotch <noreply@hoppscotch.local>",
    ONBOARDING_COMPLETED: "true",
  };
  await db.query("BEGIN");
  for (const [name, value] of Object.entries(cfg))
    await db.query('INSERT INTO "InfraConfig" (id, name, value, "isEncrypted", "updatedOn") VALUES (gen_random_uuid()::text, $1, $2, false, now()) ON CONFLICT (name) DO UPDATE SET value = EXCLUDED.value, "isEncrypted" = false, "updatedOn" = now()', [name, value]);
  const uid = (await db.query('INSERT INTO "User" (uid, email, "isAdmin") VALUES (gen_random_uuid()::text, $1, true) RETURNING uid', [email])).rows[0].uid;
  await db.query('INSERT INTO "Account" (id, "userId", provider, "providerAccountId") VALUES (gen_random_uuid()::text, $1, $2, $3)', [uid, "magic", email]);
  await db.query("COMMIT");
  console.log("[railway-start] first boot: e-mail sign-in via " + cfg.MAILER_SMTP_HOST + ", admin " + email);
  await db.end();
})().catch((e) => { console.error("[railway-start] first-boot setup failed:", e.message); process.exit(1); });
JS
# Hoppscotch stops itself (exit 0) after its first-boot setup and after every settings
# change in the admin dashboard, expecting the container to be restarted. Restart it here.
trap 'kill -TERM "$child" 2>/dev/null; exit 143' TERM INT
while :; do
  log "starting Hoppscotch"
  node /usr/src/app/aio_run.mjs & child=$!
  code=0; wait "$child" || code=$?
  pkill -x caddy 2>/dev/null || true; pkill -x webapp-server 2>/dev/null || true
  [ "$code" -eq 0 ] || exit "$code"
  log "Hoppscotch stopped to load new settings; starting it again"
  sleep 2
done

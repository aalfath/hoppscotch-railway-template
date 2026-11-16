# Hoppscotch Community Edition, all-in-one image (app, admin dashboard and backend behind Caddy).
# Release notes: https://github.com/hoppscotch/hoppscotch/releases/tag/2026.10.1
FROM hoppscotch/hoppscotch:2026.10.1@sha256:09a50aa1831ff1e39dfe73bf672e2bca45e1e73514d656e9be6a91f561071a53

# Migrates the database, finishes the first-boot onboarding (e-mail sign-in via Mailpit,
# ADMIN_EMAIL as the admin) and restarts Hoppscotch after its own planned exits.
COPY railway-start.sh /railway-start.sh
RUN chmod 0755 /railway-start.sh

# Caddy serves the app (/), the admin dashboard (/admin) and the API (/backend) on port 80.
EXPOSE 80
ENTRYPOINT ["tini", "--"]
CMD ["sh", "/railway-start.sh"]

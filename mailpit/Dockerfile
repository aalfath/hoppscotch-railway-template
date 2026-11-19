# Mailpit: a small SMTP server and web inbox that receives Hoppscotch's sign-in links
# until you configure a real mail server in the Hoppscotch admin dashboard.
# Release notes: https://github.com/axllent/mailpit/releases/tag/v1.34.0
FROM axllent/mailpit:v1.34.0@sha256:23a2ef85bc50853ab3093645d1d64679afd8887e89da5e48a88940c172591a4e

# Web UI and API on 8025 (password-protected through MP_UI_AUTH), SMTP on 1025 (private network only).
# Messages are kept in /data, which the template mounts as a volume.
EXPOSE 8025 1025
ENTRYPOINT ["/mailpit"]
CMD ["--listen", "[::]:8025", "--smtp", "[::]:1025", "--database", "/data/mailpit.db"]

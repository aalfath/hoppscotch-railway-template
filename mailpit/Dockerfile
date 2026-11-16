# Mailpit: a small SMTP server and web inbox that receives Hoppscotch's sign-in links
# until you configure a real mail server in the Hoppscotch admin dashboard.
# Release notes: https://github.com/axllent/mailpit/releases/tag/v1.33.1
FROM axllent/mailpit:v1.33.1@sha256:aef2aacc11f075ec0fb6874275ee4a421e688e11a96ebb296134d1735c7761ce

# Web UI and API on 8025 (password-protected through MP_UI_AUTH), SMTP on 1025 (private network only).
# Messages are kept in /data, which the template mounts as a volume.
EXPOSE 8025 1025
ENTRYPOINT ["/mailpit"]
CMD ["--listen", "[::]:8025", "--smtp", "[::]:1025", "--database", "/data/mailpit.db"]

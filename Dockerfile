# syntax=docker/dockerfile:1

FROM alpine:3

RUN apk update \
    && apk add --no-cache tini curl jq

COPY --chmod=755 entrypoint.sh /usr/bin/entrypoint.sh
COPY --chmod=755 backup.sh /usr/bin/backup.sh
COPY --chmod=755 api.sh /usr/bin/api.sh

ENV INSTANT_RUN=true
ENV CRON="0 3 * * *"
ENV HEALTH_FLAG="/root/health_flag"

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/entrypoint.sh"]
VOLUME ["/backups"]
WORKDIR /backups
CMD [""]

HEALTHCHECK --interval=5m \
    --start-period=5m \
    --start-interval=10s \
    CMD pgrep crond \
        && [ "$(cat $HEALTH_FLAG 2>/dev/null)" = "0" ] \
        || exit 1

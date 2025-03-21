#!/bin/sh

if [ -z "$TRELLO_KEY" ]; then
    echo "Missing environment variable: TRELLO_KEY" >&2
    exit 1
fi

if [ -z "$TRELLO_TOKEN" ]; then
    echo "Missing environment variable: TRELLO_TOKEN" >&2
    exit 1
fi

if [ $INSTANT_RUN == 'true' ]; then
    /usr/bin/backup.sh
fi

echo "$CRON /usr/bin/backup.sh" >/etc/crontabs/root

touch /var/log/cron.log
ln -sf /proc/1/fd/1 /var/log/cron.log
crond -f -l 0 >/var/log/cron.log 2>&1 &

echo "Cron started successfully."

tail -f /dev/null


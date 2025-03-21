# Github Backup

## How to use

1. Follow
   [Trello API Introduction]
   (https://developer.atlassian.com/cloud/trello/guides/rest-api/api-introduction/) to create Trello authentication key and token.

2. Put this in your docker compose file:

```yaml
trello-backup:
  image: ghcr.io/mehdi-behrooz/trello-backup:latest
  container_name: trello-backup
  restart: unless-stopped
  volumes:
    - /backups/trello/:/backups/
  environment:
    - INSTANT_RUN=true
    - CRON=0 0 * * *
    - TRELLO_KEY=$MY_TRELLO_KEY
    - TRELLO_TOKEN=$MY_TRELLO_TOKEN
```

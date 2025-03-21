#!/bin/sh

oauth="Authorization: OAuth"`
    `" oauth_consumer_key=\"$TRELLO_KEY\","`
    `" oauth_token=\"$TRELLO_TOKEN\""

list_boards() {
    curl --silent \
        --show-error \
        --fail-with-body \
        --get \
        --header "$oauth" \
        --header "Accept: application/json" \
        https://api.trello.com/1/members/me/boards
}

get_board() {
    curl --silent \
        --show-error \
        --fail-with-body \
        --get \
        --header "$oauth" \
        --header "Accept: application/json" \
        --data-urlencode "actions=all" \
        --data-urlencode "action_fields=all" \
        --data-urlencode "actions_limit=1000" \
        --data-urlencode "boardStars=mine" \
        --data-urlencode "cards=all" \
        --data-urlencode "card_fields=all" \
        --data-urlencode "card_attachments=true" \
        --data-urlencode "card_attachment_fields=all" \
        --data-urlencode "checklists=all" \
        --data-urlencode "checklists_fields=all" \
        --data-urlencode "customFields=true" \
        --data-urlencode "fields=all" \
        --data-urlencode "labels=all" \
        --data-urlencode "lists=all" \
        --data-urlencode "list_fields=all" \
        --data-urlencode "myPrefs=true" \
        --data-urlencode "tags=true" \
        https://api.trello.com/1/boards/$1
}

download_attachment() {
    curl --silent \
        --show-error \
        --header "$oauth" \
        --output-dir "$2" \
        --create-dirs \
        --remote-name \
        "$1"
}


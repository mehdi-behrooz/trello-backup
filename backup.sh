#!/bin/sh

. /usr/bin/api.sh

fix_escape_characters() {
    sed -E ':a;N;$!ba;s/\n/\\n/g; s/\\([^"\\/bfnrtu])/\\\\\1/g'
}

on_exit() {
    echo $? >$HEALTH_FLAG
}

trap on_exit EXIT

jq='
    def extract_attachments:
        .cards[].attachments[] | [.id, .url, .name] | @tsv;
'

echo "Running backup..."

if ! response=$(list_boards); then
    echo "Error: $response" >&2
    exit 1
fi

ids="$(echo $response | jq -r '.[].id')"

echo "$(echo "$ids" | wc -l) boards found."

error=0

for board_id in $ids; do

    echo "Downloading board '$board_id' ..."

    response=$(get_board $board_id)

    if ! response=$(get_board "$board_id"); then
        echo "Error: $response" >&2
        error=1
        continue
    fi

    if ! board=$(echo "$response" | fix_escape_characters | jq); then
        echo "Error: $response" >&2
        error=1
        continue
    fi

    mkdir -p /backups/$board_id/

    echo "$board" >"/backups/$board_id/board.json"

    while IFS=$'\t' read -r id url filename; do

        echo "Downloading attachment '$id' ..."

        dir="/backups/$board_id/attachments/$id/"

        if ! download_attachment "$url" "$dir"; then
            echo "Error: $response" >&2
            error=1
        fi

    done < <(echo $board | jq -r "$jq extract_attachments")

done

exit $error



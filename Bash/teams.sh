#!/bin/bash
WEBHOOK_URL=''
TITLE=""
STYLE="none"

show_usage() {
    cat << EOF
Usage: $0 -m <message> [-t <title>] [-s <style>]

<title>
Default: null

<style>
Default: default
default/emphasis/good/attention/warning/accent
EOF
}

if [ $# -eq 0 ]; then
    show_usage
    exit 0
fi

while getopts m:t:s: opts
do
    case $opts in
        m)
            MESSAGE=$OPTARG ;;
        t)
            TITLE=$OPTARG ;;
        s)
            STYLE=$OPTARG ;;
        *)
            show_usage
            exit 1
            ;;
    esac
done

if [ -z "$MESSAGE" ]; then
    echo "You must specify a message."
    exit 1
fi

formatted_output=""
while IFS= read -r line; do
    line=$(echo "$line" | /usr/bin/sed 's/ /\\u00A0/g')
    formatted_output="$formatted_output
    {
        \"type\": \"TextBlock\",
        \"style\": \"blockquote\",
        \"size\": \"small\",
        \"spacing\": \"none\",
        \"wrap\": true,
        \"text\": \"${line//\"/\\\"}\",
    },"
done <<< "$MESSAGE"
formatted_output=${formatted_output%,}

read -r -d '' adaptive_card_json << EOM
{
    "type": "message",
    "attachments": [
        {
            "contentType": "application/vnd.microsoft.card.adaptive",
            "content": {
                "\$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
                "type": "AdaptiveCard",
                "version": "1.5",
                "msteams": {
                    "width": "Full"
                },
                "body": [
                    {
                        "type": "Container",
                        "style": "$STYLE",
                        "bleed": true,
                        "spacing": "None",
                        "items": [
                            {
                                "type": "TextBlock",
                                "text": "[$(whoami)@$(hostname)] $TITLE"
                            }
                        ]
                    },
                    ${formatted_output}
                ]
            }
        }
    ]
}
EOM

curl -s -S -X POST -H "Content-Type: application/json" -d "$adaptive_card_json" $WEBHOOK_URL > /dev/null
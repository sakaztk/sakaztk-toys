#!/bin/sh
set -eu

SLACK_WEBHOOK_URL="https://hooks.slack.com/services/XXXXXXXXXX/XXXXXXXXXX"

CONTENT=""
if [ -p /dev/stdin ]; then
    if [ "`echo $@`" == "" ]; then
        CONTENT=`cat -`
    else
        CONTENT=$@
    fi
else
    CONTENT=$@
fi

if [ -z "$CONTENT" ]; then
    echo "You must specify a message."
    exit 1
fi

payload=`cat << EOS
{
  "username": "",
  "text": "",
  "mrkdwn_in": ["text"],
  "attachments": [
    {
      "title": "$(whoami)@$(hostname)",
      "color": "good",
      "mrkdwn_in": ["fields"],
      "fields": [
        {
          "title": "At",
          "value": "$(date '+%Y/%m/%d %H:%M:%S %a')",
          "short": true
        },
        {
          "title": "Content",
          "value": "${CONTENT}",
          "short": false
        }
      ]
    }
  ]
}
EOS
`
curl -s -S -X POST --data-urlencode "payload=${payload}" $SLACK_WEBHOOK_URL >/dev/null
exit 0
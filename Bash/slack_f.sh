#!/bin/sh
set -eu

SLACK_WEBHOOK_URL="https://hooks.slack.com/services/XXXXXXXXXX/XXXXXXXXXX"
LINES=0
FILE=""
TMPFILE1=$(mktemp -u)
TMPFILE2=$(mktemp -u)

show_usage() {
    echo "Usage: $0 [-f file] [-l lines]" 1>&2
}

if [ $# -eq 0 ]; then
    show_usage
    exit 0
fi

while getopts f:l: opts
do
    case $opts in
        f)
            FILE=$OPTARG ;;
        l)
            LINES=$OPTARG ;;
        *)
            show_usage
            exit 1
            ;;
    esac
done

if [ $FILE = "" ]; then
    echo "You must specify a file."
    exit 1
elif [ $LINES -eq 0 ]; then
    CONTENT=`cat $FILE`
else
    CONTENT=`tail -n${LINES} $FILE`
    FILE="$FILE (Last $LINES lines)"
fi

cat << EOS > $TMPFILE1
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
          "title": "File Name",
          "value": "${FILE}",
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

tr -d '\000-\010\013-\037' < $TMPFILE1 > $TMPFILE2
curl -sS -X POST $SLACK_WEBHOOK_URL --data-urlencode payload@$TMPFILE2
rm -f $TMPFILE1 $TMPFILE2
echo
exit 0
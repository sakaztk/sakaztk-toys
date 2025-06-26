#!/bin/bash
SSH_USER=manage
SSH_PASS=P@ssw0rd
SSH_HOST=192.168.0.1
if [ -n "$PASSWORD" ]; then
    cat <<< "$PASSWORD"
    exit 0
fi
export PASSWORD=$SSH_PASS
export SSH_ASKPASS=$0
export DISPLAY=dummy:0

# Unmount MSA Disks
umount -f /disk1
umount -f /disk2

# Shutdown MSA
echo y | exec setsid ssh -o "StrictHostKeyChecking no" $SSH_USER@$SSH_HOST "shutdown both" > /dev/null

shutdown -h now



i=0
while [ $i -ne 10 ]; do
    ENCLOSURE_COUNT=`exec setsid ssh -o "StrictHostKeyChecking no" $SSH_USER@$SSH_HOST "set cli-parameters console; show system" | grep "Enclosure Count" | sed -e "s/\(Enclosure Count: \)\(.*$\)/\2/g"`
    if [ $ENCLOSURE_COUNT = 2 ]; then
        echo "OK"
        break
    else
        echo y | exec setsid ssh -o "StrictHostKeyChecking no" $SSH_USER@$SSH_HOST "rescan" > /dev/null
        sleep 120
    fi
    i=`expr 1 + $i`
    if [ $i = 10 ]; then
        echo "Unexpected enclosure count: ${ENCLOSURE_COUNT}" >&2
        exit 1
    fi
done

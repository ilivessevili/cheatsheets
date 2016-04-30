#!/bin/bash -eu
# find the listening port by instance name when serial console is enabled

[ -n "$1" ] || exit 1

UUID=`nova list | grep $1 | awk '{print $2 }'`

PORT=`ps -ef | grep $UUID | grep -iEo port=.{5}`

echo "instance name: $1 =>  $PORT"

#!/usr/bin/env bash

[[ `pgrep -f "quai-gpu-miner-nvidia --api-bind" | wc -l` != 0 ]] &&
  echo -e "${RED}$CUSTOM_NAME miner is already running${NOCOLOR}" &&
  exit 1

. h-manifest.conf

conf=`cat $MINER_CONFIG_FILENAME`

if [[ $conf =~ ';' ]]; then
    conf=`echo $conf | tr -d '\\'`
fi

eval "unbuffer ./quai-gpu-miner-nvidia ${conf//;/'\;'} --api-bind 127.0.0.1:21373"

sleep 10
#!/bin/bash

if [ -n "${LOGFILE}" ]; then
  TIMESTAMP=`date "+%y%m%d-%H%M%S"`
  echo "${TIMESTAMP}: KILLSWITCH ACTIVATED" >> /data/logs/${LOGFILE}
fi

if [ "${OVPNKS}" == "ACTIVE" ]; then
# ps ax | grep -v grep | grep 'BiglyBT.jar' | awk '{print $1}' | xargs kill
  pkill java
fi

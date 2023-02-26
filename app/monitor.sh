#!/bin/bash

OVPID=`pgrep openvpn`
while [ x"${OVPID}" != "x" ]; do
  sleep 1
  OVPID=`pgrep openvpn`
done

sleep 2

if [ -n "${LOGFILE}" ]; then
  TIMESTAMP=`date "+%y%m%d-%H%M%S"`
  echo "${TIMESTAMP}: MONITOR ACTIVATING KILLSWITCH" >> /data/logs/${LOGFILE}

# ps a >> /out/${LOGFILE}
# cat /var/log/openvpn/openvpn.log >> /data/logs/${LOGFILE}
fi

/app/killswitch.sh

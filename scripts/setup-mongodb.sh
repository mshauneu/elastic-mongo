#!/bin/bash
apt-get update && apt-get install -y curl && apt-get clean

MONGODB1=`ping -c 1 mongo1 | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`
MONGODB2=`ping -c 1 mongo2 | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`

echo "Waiting for startup.."
until curl http://${MONGODB1}:28117/serverStatus\?text\=1 2>&1 | grep uptime | head -1; do
  printf '.'
  sleep 1
done

echo curl -s http://${MONGODB1}:28117/serverStatus\?text\=1 2>&1 | grep uptime | head -1
echo "Started."

mongo --host ${MONGODB1}:27017 <<EOF
   var cfg = {
        "_id": "rs",
        "version": 1,
        "members": [
            {
                "_id": 0,
                "host": "${MONGODB1}:27017",
                "priority": 2
            },
            {
                "_id": 1,
                "host": "${MONGODB2}:27017",
                "priority": 0
            }
        ]
    };
    rs.initiate(cfg, { force: true });
    rs.reconfig(cfg, { force: true });
EOF

#!/bin/bash

# Wait
MONGODB1=`ping -c 1 mongo1 | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`
ES=`ping -c 1 es1 | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`

echo "Waiting for the mongos to complete the election."
until curl -s http://${MONGODB1}:28017/isMaster\?text\=1  2>&1 | grep ismaster | grep true; do
  printf '.'
  sleep 1
done
echo "The primary is elected."

echo "Waiting for Elasticsearch to start."
until curl -s ${ES}:9200/_cluster/health?pretty 2>&1 | grep status | egrep "(green|yellow)"; do
  printf '.'
  sleep 1
done
echo "Elasticsearch started."

transporter run --config /transporter/config.yaml /transporter/application.js

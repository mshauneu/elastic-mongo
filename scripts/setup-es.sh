#!/bin/bash
apt-get update && apt-get install -y curl && apt-get clean

ES=`ping -c 1 es1 | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`

echo "Waiting for ES startup.."
until curl -s ${ES}:9200/_cluster/health?pretty | grep status | egrep "(green|yellow)" 2>&1; do
  printf '.'
  sleep 2
done
echo "Started."

curl -s -XPUT ${ES}:9200/_cluster/settings -d '{
    "transient" : {
        "cluster.routing.allocation.disk.threshold_enabled" : false
    }
}'

curl -s -XPUT ${ES}:9200/harvester-test/ -d '{
    "settings" : {
        "index" : {
            "number_of_shards" : 1, 
            "number_of_replicas" : 2 
        }
    }
}'

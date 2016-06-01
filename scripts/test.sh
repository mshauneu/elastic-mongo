#!/bin/bash
apt-get update && apt-get install -y curl && apt-get clean

MONGODB1=`ping -c 1 mongo1 | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`
MONGODB2=`ping -c 1 mongo2 | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`
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


echo "================================="
echo "Writing to MongoDB"
mongo ${MONGODB1} <<EOF
  use harvester-test
  rs.config()
  var p = {title: "Breaking news", content: "It's not summer yet."}
  db.entries.save(p)
EOF


echo "================================="
echo "Fetching data from Mongo"
echo curl -s http://${MONGODB1}:28017/harvester-test/entries/?limit=10
curl -s http://${MONGODB1}:28017/harvester-test/entries/?limit=10
echo "================================="


printf "\nReading from Elasticsearch (waiting for the transporter to start)\n\n"
sleep 40
curl -s -XGET "http://${ES}:9200/harvester-test/entries/_search"


echo "================================="
echo "DONE"

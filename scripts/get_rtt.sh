#!/bin/bash

DB_NAME=net
DB_TABLE=ping_stats
DB_USER=net_user
DB_HOST=localhost
DB_PASSWORD=net_password

HEAD_LINE=$((1 + $1))
TAIL_LINE=$((0 + $1))
HOST=
PACKETS=$1

ping -c $PACKETS $HOST | while read pong; do echo "$(date '+%F %T'): $pong"; done | head --lines $HEAD_LINE | tail --lines $TAIL_LINE > ping_stats.tmp

while IFS= read -r line
do
	DATE=$(echo $line | cut -d' ' -f1)
	HOUR=$(echo $line | cut -d' ' -f2 | cut -c 1-8)
	TIMESTAMP="$DATE $HOUR"
	RTT=$(echo $line | cut -d' ' -f9 | cut -d'=' -f2)

	QUERY="INSERT INTO $DB_TABLE VALUES (NULL, $RTT, '$TIMESTAMP');"

	sudo docker exec mysql mysql -u $DB_USER -p$DB_PASSWORD $DB_NAME -h $DB_HOST -e "$QUERY"
done < ping_stats.tmp

rm ping_stats.tmp
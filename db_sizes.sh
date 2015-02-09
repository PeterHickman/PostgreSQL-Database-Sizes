#!/bin/sh

for DB in `psql -l | grep '|' | awk '{print $1}' | egrep -v '(Name|template0|template1|postgres|\|)'`
do
    COUNT=`psql -c "SELECT pg_size_pretty(pg_database_size('$DB'));" | head -3 | tail -1`
    printf "Database ..: %-30s %12s\n" $DB "$COUNT"
    for TABLE in `psql $DB -c '\dt' | awk '/table/{print $3}'`
    do
        ROWS=`psql $DB -c "SELECT COUNT(*) FROM $TABLE" | head -3 | tail -1`
        SIZE=`psql $DB -c "SELECT pg_size_pretty(pg_total_relation_size('$TABLE'));" | head -3 | tail -1`
        printf "Table .....: %-30s %12d %12s\n" $TABLE $ROWS "$SIZE"
    done
    echo
done

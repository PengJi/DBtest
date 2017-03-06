SF=1
for q in `seq 1 22`
do
    DSS_QUERY=dss/templates ./qgen -s $SF $q > dss/sql/$q.sql
    sed 's/^select/explain select/' dss/sql/$q.sql > dss/sql/$q.explain.sql
done

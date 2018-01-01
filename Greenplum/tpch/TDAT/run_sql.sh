for r in `seq 1 10`
do
	rn=$((`cat /dev/urandom|od -N3 -An -i` % 10000))
	DSS_QUERY=queries ./qgen 3 5 -r $rn >> benchmark.sql
done

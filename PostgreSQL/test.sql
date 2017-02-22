\set aid random(1, 100000 * :scale)
\set bid random(1, 1 * :scale)
\set tid random(1, 10 * :scale)
\set delta random(-5000, 5000)
BEGIN;
-- pgbench_accounts:作为最大的表，起到促发磁盘I/O的作用
UPDATE pgbench_accounts SET abalance = abalance + :delta WHERE aid = :aid;
-- abalance:由于上一条UPDATE语句更新一些信息，存在于缓存内用于回应这个查询
SELECT abalance FROM pgbench_accounts WHERE aid = :aid;
-- pgbench_tellers:职员的数量比账号的数量要少得多，所以这个表也很小，并且极有可能存在于内存中
UPDATE pgbench_tellers SET tbalance = tbalance + :delta WHERE tid = :tid;
-- pgbench_branches:作为更小的表，内容被缓存，如果用户的环境是数量较小的数据库和多个客户端时，对其锁操作可能会成为性能的瓶颈
UPDATE pgbench_branches SET bbalance = bbalance + :delta WHERE bid = :bid;
-- pgbench_history:history表是个附加表，后续并不会进行更新或查询操作，而且也没有任何索引。相对于UPDATE语句，对其的插入操作对磁盘的写入成本也很小
INSERT INTO pgbench_history (tid, bid, aid, delta, mtime) VALUES (:tid, :bid, :aid, :delta, CURRENT_TIMESTAMP);
END;

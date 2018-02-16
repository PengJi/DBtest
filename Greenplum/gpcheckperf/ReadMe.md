gpcheckperf
磁盘I/O测试  
内存带宽测试  
网络性能测试  

[gpcheckperf](https://gpdb.docs.pivotal.io/530/utility_guide/admin_utilities/gpcheckperf.html)  
[Greenplum数据库文档 gpcheckperf](https://gp-docs-cn.github.io/docs/utility_guide/admin_utilities/gpcheckperf.html)

```
git clone git@github.com:HewlettPackard/netperf.git
./configure --prefix=/home/gpadmin/greenplum/bin/lib
automake --add-missing
make -j 2
make install

gpcheckperf -f gpconfigs/all_hosts -r dsN --netperf -d /home/gpadmin/tmp -V -D
```

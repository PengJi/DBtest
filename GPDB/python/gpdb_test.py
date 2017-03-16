#coding: utf-8

import multiprocessing
import threading
import Queue
import os
import time
import random
import subprocess

from tran import TranClass
from funs import *

# num  线程的个数
# size 数据的大小，1、10、20、50、100
def main(num,size):
    pool = multiprocessing.Pool(processes = 100)

    # 清空缓存
    print str_style('clear caches', fore = 'green')
    clear_cache()

    print str_style("main process eecution", fore = "yellow")
    start = time.time()

    for i in xrange(0,num):
        ran = i % 5
        ran = ran +1
        if ran == 1:
            strsql1 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-1.sql'
            strsql2 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-2.sql'
            strsql3 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-1_1.sql'
        elif ran == 2:
            strsql1 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-2.sql'
            strsql2 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-2_1.sql'
            strsql3 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-3_1.sql'        
        elif ran == 3:
            strsql1 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-3.sql'
            strsql2 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-3_1.sql'
            strsql3 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-4_2.sql'              
        elif ran == 4:
            strsql1 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-4.sql'
            strsql2 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-4_1.sql'
            strsql3 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-4_2.sql'
        elif ran == 5:
            strsql1 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-4.sql'
            strsql2 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-4_1.sql'
            strsql3 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-4_2.sql'
        pool.apply_async(tenant,args=("tenant"+str(ran),strsql1,strsql2,strsql3))

    pool.close()
    pool.join()
    end = time.time()
    str_run = 'process run %0.2f seconds.' %(end - start)
    print str_style(str_run,fore='red')
    subprocess.check_output(['echo ' + str_run + ' >> run.log'],shell=True)
    print str_style("Sub-process(es) done.", fore = "yellow")

if __name__ == "__main__":
    # 创建role
    #create_role(1,100)

    # 创建schema
    #create_schema(1,100)

    # 创建queue
    #create_queue(1,100)

    str_sep = '=================================='
    # 删除目录下文件
    delete_file_folder('/home/gpadmin/DBtest/GPDB/python/res_process')

    subprocess.check_output(['echo ' + '10 processes 1G data' + ' >> run.log'],shell=True)
    for i in xrange(10):
        subprocess.check_output(['echo 10 of process ' + str(i) + ' time >> run.log'],shell=True)
        main(10,1)

    subprocess.check_output(['echo ' + str_sep + ' >> run.log'],shell=True)
    subprocess.check_output(['echo ' + '20 processes 1G data' + ' >> run.log'],shell=True)
    for i in xrange(10):
        subprocess.check_output(['echo 20 of process ' + str(i) + ' time >> run.log'],shell=True)
        main(20,1)

    subprocess.check_output(['echo ' + str_sep + ' >> run.log'],shell=True)
    subprocess.check_output(['echo ' + '50 processes 1G data' + ' >> run.log'],shell=True)
    for i in xrange(10):
        subprocess.check_output(['echo 50 of process ' + str(i) + ' time >> run.log'],shell=True)
        main(50,1)


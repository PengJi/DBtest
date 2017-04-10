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
def test_photoobjall(num,size):
    pool = multiprocessing.Pool(processes = 30)

    # 清空缓存
    clear_cache()

    print str_style("main function execute", fore = "yellow")
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
    print str_style("main function complete", fore = "yellow")

# 执行测试
def run_photoobjall():
    # 测试1G数据
    subprocess.check_output(['echo ' + '10 processes 1G data' + ' >> run.log'],shell=True)
    for i in xrange(10):
        subprocess.check_output(['echo 10 of process ' + str(i) + ' time >> run.log'],shell=True)
        test_photoobjall(10,1)

    subprocess.check_output(['echo ' + str_sep + ' >> run.log'],shell=True)
    subprocess.check_output(['echo ' + '20 processes 1G data' + ' >> run.log'],shell=True)
    for i in xrange(10):
        subprocess.check_output(['echo 20 of process ' + str(i) + ' time >> run.log'],shell=True)
        test_photoobjall(20,1)

    subprocess.check_output(['echo ' + str_sep + ' >> run.log'],shell=True)
    subprocess.check_output(['echo ' + '50 processes 1G data' + ' >> run.log'],shell=True)
    for i in xrange(10):
        subprocess.check_output(['echo 50 of process ' + str(i) + ' time >> run.log'],shell=True)
        test_photoobjall(50,1)

    # 测试10G数据
    subprocess.check_output(['echo ' + '10 processes 10G data' + ' >> run.log'],shell=True)
    for i in xrange(10):
        subprocess.check_output(['echo 10 of process ' + str(i) + ' time >> run.log'],shell=True)
        test_photoobjall(10,10)

    subprocess.check_output(['echo ' + str_sep + ' >> run.log'],shell=True)
    subprocess.check_output(['echo ' + '20 processes 10G data' + ' >> run.log'],shell=True)
    for i in xrange(10):
        subprocess.check_output(['echo 20 of process ' + str(i) + ' time >> run.log'],shell=True)
        test_photoobjall(20,10)

    subprocess.check_output(['echo ' + str_sep + ' >> run.log'],shell=True)
    subprocess.check_output(['echo ' + '50 processes 10G data' + ' >> run.log'],shell=True)
    for i in xrange(10):
        subprocess.check_output(['echo 50 of process ' + str(i) + ' time >> run.log'],shell=True)
        test_photoobjall(50,10)

    # 测试20G数据
    subprocess.check_output(['echo ' + '10 processes 20G data' + ' >> run.log'],shell=True)
    for i in xrange(10):
        subprocess.check_output(['echo 10 of process ' + str(i) + ' time >> run.log'],shell=True)
        test_photoobjall(10,20)

    subprocess.check_output(['echo ' + str_sep + ' >> run.log'],shell=True)
    subprocess.check_output(['echo ' + '20 processes 20G data' + ' >> run.log'],shell=True)
    for i in xrange(10):
        subprocess.check_output(['echo 20 of process ' + str(i) + ' time >> run.log'],shell=True)
        test_photoobjall(20,20)

    subprocess.check_output(['echo ' + str_sep + ' >> run.log'],shell=True)
    subprocess.check_output(['echo ' + '50 processes 20G data' + ' >> run.log'],shell=True)
    for i in xrange(10):
        subprocess.check_output(['echo 50 of process ' + str(i) + ' time >> run.log'],shell=True)
        test_photoobjall(50,20)

    # 测试50G数据
    subprocess.check_output(['echo ' + '10 processes 50G data' + ' >> run.log'],shell=True)
    for i in xrange(10):
        subprocess.check_output(['echo 10 of process ' + str(i) + ' time >> run.log'],shell=True)
        test_photoobjall(10,50)

    subprocess.check_output(['echo ' + str_sep + ' >> run.log'],shell=True)
    subprocess.check_output(['echo ' + '20 processes 50G data' + ' >> run.log'],shell=True)
    for i in xrange(10):
        subprocess.check_output(['echo 20 of process ' + str(i) + ' time >> run.log'],shell=True)
        test_photoobjall(20,50)

    subprocess.check_output(['echo ' + str_sep + ' >> run.log'],shell=True)
    subprocess.check_output(['echo ' + '50 processes 50G data' + ' >> run.log'],shell=True)
    for i in xrange(10):
        subprocess.check_output(['echo 50 of process ' + str(i) + ' time >> run.log'],shell=True)
        test_photoobjall(50,50)

# num  线程的个数
# size 数据的大小，1、10、20、50、100
def test_queries(num,size):
    # 允许同时运行的进程个数
    pool = multiprocessing.Pool(processes = 30)

    # 清空缓存
    clear_cache()

    print str_style("main function execute", fore = "yellow")
    start = time.time()

    for i in xrange(0,num):
        ran = i % 10
        ran = ran +1
        if ran == 1:
            strsql1 = "select fQ2" + "_" + str(size) + "()"
            strsql2 = "select fQ3" + "_" + str(size) + "()"
            strsql3 = "select fQ15" + "_" + str(size) + "()"
        elif ran == 2:
            strsql1 = "select fQ5" + "_" + str(size) + "()"
            strsql2 = "select fQ20" + "_" + str(size) + "()"
            strsql3 = "select fQ7" + "_" + str(size) + "()"
        elif ran == 3:
            strsql1 = "select fQ13" + "_" + str(size) + "()"
            strsql2 = "select fQ14" + "_" + str(size) + "()"
            strsql3 = "select fQ3" + "_" + str(size) + "()"
        elif ran == 4:
            strsql1 = "select fQ16"+ "_" + str(size) + "()"
            strsql2 = "select fQ17" + "_" + str(size) + "()"
            strsql3 = "select fQ4" + "_" + str(size) + "()"
        elif ran == 5:
            strsql1 = "select fQ20" + "_" + str(size) + "()"
            strsql2 = "select fQ14" + "_" + str(size) + "()"
            strsql3 = "select fQ5" + "_" + str(size) + "()"
        elif ran == 6:
            strsql1 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-1.sql'
            strsql2 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-2.sql'
            strsql3 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-1_1.sql'
        elif ran == 7:
            strsql1 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-2.sql'
            strsql2 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-2_1.sql'
            strsql3 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-3_1.sql'
        elif ran == 8:
            strsql1 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-4.sql'
            strsql2 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-4_1.sql'
            strsql3 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-4_2.sql'
        elif ran == 9:
            strsql1 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-3.sql'
            strsql2 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-3_1.sql'
            strsql3 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-4_2.sql'             
        elif ran == 10:
            strsql1 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-4.sql'
            strsql2 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-4_1.sql'
            strsql3 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-'+str(size)+'-4_2.sql'

        if ran <= 5:
            pool.apply_async(tenant,args=("tenant"+str(ran),strsql1,strsql2,strsql3,'c'))
        else: 
            pool.apply_async(tenant,args=("tenant"+str(ran),strsql1,strsql2,strsql3,'f'))

    pool.close()
    pool.join()
    end = time.time()
    str_run = 'process run %0.2f seconds.' %(end - start)
    print str_style(str_run,fore='red')
    subprocess.check_output(['echo ' + str_run + ' >> run.log'],shell=True)
    print str_style("complete", fore = "yellow")

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

    # 100个进程(租户)
    test_queries(100,10)
    test_queries(100,20)
    test_queries(100,50)


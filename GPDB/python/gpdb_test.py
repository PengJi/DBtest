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

'''
测试多租户
'''
# 测试函数
def func(msg):
	print "msg:", msg
	time.sleep(2)
	print "end"

database = 'testDB'
host = '192.168.100.78'

# 租户进程
def tenant1():
    print 'tenant1'
    user = 'tenant1'
    queue = Queue.Queue()
    strsql1 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-1.sql'
    strsql2 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-2.sql'
    strsql3 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-1_1.sql'

    print "tenant1 start time is:", time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    print str_style('tenant1 query start', fore = 'green')
    start = time.time()

	# query sql
    p1 = TranClass(queue, user, database, host, strsql1)
    p2 = TranClass(queue, user, database, host, strsql2)
    p3 = TranClass(queue, user, database, host, strsql3)
    p1.start()
    p2.start()
    p3.start()
    p1.join()
    p2.join()
    p3.join()

    end = time.time()   
    print str_style("tenant1 query completed", fore = 'green')
    print "tenant1 end time is:",time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    str_run = 'tenant1 task runs %0.2f seconds.' %(end - start)
    print str_style(str_run,fore='red')
    subprocess.check_output(['echo ' + str_run + ' >> run.log'],shell=True)

    fo = open("res_process/tenant1.txt","a")
    while not queue.empty():
        fo.write(queue.get())
    fo.close()

# 租户进程
def tenant2():
    print 'tenant2'
    user = 'tenant2'
    queue = Queue.Queue()
    strsql1 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-2.sql'
    strsql2 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-2_1.sql'
    strsql3 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-3_1.sql'

    print "tenant2 start time is:",time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    print str_style('tenant2 query start', fore = 'green')
    start = time.time()

	# query sql
    p1 = TranClass(queue, user,database,host,strsql1)
    p2 = TranClass(queue, user,database,host,strsql2)
    p3 = TranClass(queue, user,database,host,strsql3)
    p1.start()
    p2.start()
    p3.start()
    p1.join()
    p2.join()
    p3.join()

    end = time.time()   
    print str_style("tenant2 query completed", fore = 'green')
    print "tenant2 end time is:",time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    str_run = 'tenant2 task runs %0.2f seconds.' %(end - start)
    print str_style(str_run,fore='red')
    subprocess.check_output(['echo ' + str_run + ' >> run.log'],shell=True)

    fo = open("res_process/tenant2.txt","a")
    while not queue.empty():
        fo.write(queue.get())
    fo.close()

# 租户进程
def tenant3():
    print 'tenant3'
    user = 'tenant3'
    queue = Queue.Queue()
    strsql1 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-3.sql'
    strsql2 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-3_1.sql'
    strsql3 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-4_2.sql'

    print "tenant3 start time is:",time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    print str_style('tenant3 query start', fore = 'green')
    start = time.time()

	# query sql
    p1 = TranClass(queue, user,database,host,strsql1)
    p2 = TranClass(queue, user,database,host,strsql2)
    p3 = TranClass(queue, user,database,host,strsql3)
    p1.start()
    p2.start()
    p3.start()
    p1.join()
    p2.join()
    p3.join()

    end = time.time()   
    print str_style("tenant3 query completed", fore = 'green')
    print "tenant3 end time is:",time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    str_run = 'tenant3 task runs %0.2f seconds.' %(end - start)
    print str_style(str_run,fore='red')
    subprocess.check_output(['echo ' + str_run + ' >> run.log'],shell=True)

    fo = open("res_process/tenant3.txt","a")
    while not queue.empty():
        fo.write(queue.get())
    fo.close()

# 租户进程
def tenant4():
    print 'tenant4'
    user = 'tenant4'
    queue = Queue.Queue()
    strsql1 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-4.sql'
    strsql2 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-4_1.sql'
    strsql3 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-4_2.sql'

    print "tenant4 start time is:",time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    print str_style('tenant4 query start', fore = 'green')
    start = time.time()

	# query sql
    p1 = TranClass(queue, user,database,host,strsql1)
    p2 = TranClass(queue, user,database,host,strsql2)
    p3 = TranClass(queue, user,database,host,strsql3)
    p1.start()
    p2.start()
    p3.start()
    p1.join()
    p2.join()
    p3.join()

    end = time.time()   
    print str_style("tenant4 query completed", fore = 'green')
    print "tenant4 end time is:",time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    str_run = 'tenant4 task runs %0.2f seconds.' %(end - start)
    print str_style(str_run,fore='red')
    subprocess.check_output(['echo ' + str_run + ' >> run.log'],shell=True)

    fo = open("res_process/tenant4.txt","a")
    while not queue.empty():
        fo.write(queue.get())
    fo.close()

# 租户进程
def tenant5():
    print 'tenant5'
    user = 'tenant5'
    queue = Queue.Queue()
    strsql1 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-2.sql'
    strsql2 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-3.sql'
    strsql3 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-4.sql'

    print "tenant5 start time is:",time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    print str_style('tenant5 query start', fore = 'green')
    start = time.time()

	# query sql
    p1 = TranClass(queue, user,database,host,strsql1)
    p2 = TranClass(queue, user,database,host,strsql2)
    p3 = TranClass(queue, user,database,host,strsql3)
    p1.start()
    p2.start()
    p3.start()
    p1.join()
    p2.join()
    p3.join()

    end = time.time()   
    print str_style("tenant5 query completed", fore = 'green')
    print "tenant5 end time is:",time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    str_run = 'tenant5 task runs %0.2f seconds.' %(end - start)
    print str_style(str_run,fore='red')
    subprocess.check_output(['echo ' + str_run + ' >> run.log'],shell=True)

    fo = open("res_process/tenant5.txt","a")
    while not queue.empty():
        fo.write(queue.get())
    fo.close()

# 主函数
def main(num):
    pool = multiprocessing.Pool(processes = 100)

    # 清空缓存
    print str_style('clear caches', fore = 'green')
    sshclient('sync; echo 1 > /proc/sys/vm/drop_caches')

    # 删除目录下文件
    delete_file_folder('/home/gpadmin/DBtest/GPDB/python/res_process')

    '''
    # 测试pool(带参数)
    for i in xrange(5):
        msg = "hello %d" %(i)
        pool.apply_async(func, (msg, ))  # 向pool中添加进程
    '''

    # 创建role
    #create_role(1,100)

    # 创建schema
    #create_schema(1,100)

    # 创建queue
    #create_queue(1,100)

    print str_style("main process eecution", fore = "yellow")
    start = time.time()

    for i in xrange(1,num):
        #ran = random.randint(1,i) % 6
        ran = i % 6
        pool.apply_async(globals().get('tenant'+str(ran)),())

    # 关闭pool，使其不再接受新的任务
    pool.close()
    # 主进程阻塞，等待子进程的退出 
    pool.join()
    end = time.time()
    str_run = 'process run %0.2f seconds.' %(end - start)
    print str_style(str_run,fore='red')
    subprocess.check_output(['echo ' + str_run + ' >> run.log'],shell=True)
    print str_style("Sub-process(es) done.", fore = "yellow")

if __name__ == "__main__":
    str_sep = '======================================================================'
    for i in xrange(10):
        subprocess.check_output(['echo ' + '10 processes' + ' >> run.log'],shell=True)
        main(10)
    subprocess.check_output(['echo ' + str_sep + ' >> run.log'],shell=True)
    for i in xrange(10):
        subprocess.check_output(['echo ' + '20 processes' + ' >> run.log'],shell=True)
        main(20)
    subprocess.check_output(['echo ' + str_sep + ' >> run.log'],shell=True)
    for i in xrange(10):
        subprocess.check_output(['echo ' + '50 processes' + ' >> run.log'],shell=True)
        main(50)

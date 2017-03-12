#coding: utf-8

import multiprocessing
import threading
import os
import time
import random
import subprocess  

from shell_color import str_style
from tran import TranClass

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
    user = 'tenant1'
    strsql1 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-1.sql'
    strsql2 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-2.sql'
    strsql3 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-1_1.sql'

    start = time.time()
    print "start time is: ",time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    print str_style('query start', fore = 'green')

	# query sql
    p1 = TranClass(user,database,host,strsql1)
    p2 = TranClass(user,database,host,strsql2)
    p3 = TranClass(user,database,host,strsql3)
    p1.start()
    p2.start()
    p3.start()
    p1.join()
    p2.join()
    p3.join()

    print str_style("query completed", fore = 'green')
    end = time.time()   
    print "end time is: ",time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    print 'Task runs %0.2f seconds.' %(end - start)

# 租户进程
def tenant2():
    print 'tenant2'
    user = 'tenant2'
    strsql1 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-2.sql'
    strsql2 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-2_1.sql'
    strsql3 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-3_1.sql'

    start = time.time()
    print "start time is: ",time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    print str_style('query start', fore = 'green')

	# query sql
    p1 = TranClass(user,database,host,strsql1)
    p2 = TranClass(user,database,host,strsql2)
    p3 = TranClass(user,database,host,strsql3)
    p1.start()
    p2.start()
    p3.start()
    p1.join()
    p2.join()
    p3.join()

    print str_style("query completed", fore = 'green')
    end = time.time()   
    print "end time is: ",time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    print 'Task runs %0.2f seconds.' %(end - start)

# 租户进程
def tenant3():
    print 'tenant3'
    user = 'tenant3'
    strsql1 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-3.sql'
    strsql2 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-3_1.sql'
    strsql3 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-4_2.sql'

    start = time.time()
    print "start time is: ",time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    print str_style('query start', fore = 'green')

	# query sql
    p1 = TranClass(user,database,host,strsql1)
    p2 = TranClass(user,database,host,strsql2)
    p3 = TranClass(user,database,host,strsql3)
    p1.start()
    p2.start()
    p3.start()
    p1.join()
    p2.join()
    p3.join()

    print str_style("query completed", fore = 'green')
    end = time.time()   
    print "end time is: ",time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    print 'Task runs %0.2f seconds.' %(end - start)

# 租户进程
def tenant4():
    print 'tenant4'
    user = 'tenant4'
    strsql1 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-4.sql'
    strsql2 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-4_1.sql'
    strsql3 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-4_2.sql'

    start = time.time()
    print "start time is: ",time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    print str_style('query start', fore = 'green')

	# query sql
    p1 = TranClass(user,database,host,strsql1)
    p2 = TranClass(user,database,host,strsql2)
    p3 = TranClass(user,database,host,strsql3)
    p1.start()
    p2.start()
    p3.start()
    p1.join()
    p2.join()
    p3.join()

    print str_style("query completed", fore = 'green')
    end = time.time()   
    print "end time is: ",time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    print 'Task runs %0.2f seconds.' %(end - start)

# 租户进程
def tenant5():
    print 'tenant5'
    user = 'tenant1'
    strsql1 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-2.sql'
    strsql2 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-3.sql'
    strsql3 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-4.sql'

    start = time.time()
    print "start time is: ",time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    print str_style('query start', fore = 'green')

	# query sql
    p1 = TranClass(user,database,host,strsql1)
    p2 = TranClass(user,database,host,strsql2)
    p3 = TranClass(user,database,host,strsql3)
    p1.start()
    p2.start()
    p3.start()
    p1.join()
    p2.join()
    p3.join()

    print str_style("query completed", fore = 'green')
    end = time.time()   
    print "end time is: ",time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    print 'Task runs %0.2f seconds.' %(end - start)

# 租户进程
def tenant6():
    print 'tenant6'

# 租户进程
def tenant7():
    print 'tenant7'

# 租户进程
def tenant8():
    print 'tenant8'

# 租户进程
def tenant9():
    print 'tenant9'

if __name__ == "__main__":
    pool = multiprocessing.Pool(processes = 5)

    # 测试pool
    for i in xrange(5):
        msg = "hello %d" %(i)
        pool.apply_async(func, (msg, ))  # 向pool中添加进程

    print str_style("main process eecution", fore = "red") 
    pool.apply_async(tenant1, ())
    pool.apply_async(tenant2, ())
    pool.apply_async(tenant3, ())
    pool.apply_async(tenant4, ())
    pool.apply_async(tenant5, ())
    pool.apply_async(tenant6, ())
    pool.apply_async(tenant7, ())
    pool.apply_async(tenant8, ())
    pool.apply_async(tenant9, ())

    # 关闭pool，使其不再接受新的任务
    pool.close()
    # 主进程阻塞，等待子进程的退出 
    pool.join()
    
    print str_style("Sub-process(es) done.", fore = "red")
    

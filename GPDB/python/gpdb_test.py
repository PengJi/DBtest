#coding: utf-8

import multiprocessing
import threading
import os
import time
import random
import subprocess  # 执行shell命令

from shell_color import str_style
import tran

'''
测试多租户
'''
def func(msg):
	print "msg:", msg
	time.sleep(2)
	print "end"

def writer_proc(q):
    try:
        q.put(1, block = False)
    except:
        pass

def reader_proc(q):
    try:
        print q.get(block = False)
    except:
        pass

# queue写数据进程
def write_proc(q):
    for value in ['A', 'B', 'C']:
        print 'Put %s to queue...' % value
        q.put(value)
        time.sleep(random.random())

# queue读数据进程
def read_proc(q):
    while True:
        value = q.get(True)
        print 'Get %s from queue.' % value

def tenant1():
    start = time.time()
    print "start time is: ",time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    print shell_color.str_style('query start', fore = 'green')

	# query sql
    p1 = Tranclass('gpadmin','testDB','/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-1.sql')
    p2 = Tranclass('gpadmin','testDB','/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-2.sql')
    p3 = Tranclass('gpadmin','testDB','/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-3.sql')
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
    return res

def tenant2():
    start = time.time()
    print str_style('query start', fore = 'green')
	# query sql
    res = subprocess.check_output(["psql","-U","gpadmin","-d","testDB","-f","/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-1_1.sql"])
    print res
    print str_style("query completed", fore = 'green')
    end = time.time()    
    print 'Task runs %0.2f seconds.' %(end - start)
    return res

def tenant3():
    start = time.time()
    print str_style('query start', fore = 'green')
	# query sql
    res = subprocess.check_output(["psql","-U","gpadmin","-d","testDB","-f","/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-2.sql"])
    print res
    print str_style("query completed", fore = 'green')
    end = time.time()    
    print 'Task runs %0.2f seconds.' %(end - start)
    return res

def tenant4():
    start = time.time()
    print str_style('query start', fore = 'green')
	# query sql
    res = subprocess.check_output(["psql","-U","gpadmin","-d","testDB","-f","/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-2_1.sql"])
    print res
    print str_style("query completed", fore = 'green')
    end = time.time()    
    print 'Task runs %0.2f seconds.' %(end - start)
    return res

def tenant5():
    start = time.time()
    print str_style('query start', fore = 'green')
	# query sql
    res = subprocess.check_output(["psql","-U","gpadmin","-d","testDB","-f","/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-3.sql"])
    print res
    print str_style("query completed", fore = 'green')
    end = time.time()    
    print 'Task runs %0.2f seconds.' %(end - start)
    return res

def tenant6():
    start = time.time()
    print str_style('query start', fore = 'green')
	# query sql
    res = subprocess.check_output(["psql","-U","gpadmin","-d","testDB","-f","/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-3_1.sql"])
    print res
    print str_style("query completed", fore = 'green')
    end = time.time()    
    print 'Task runs %0.2f seconds.' %(end - start)
    return res

def tenant7():
    start = time.time()
    print str_style('query start', fore = 'green')
	# query sql
    res = subprocess.check_output(["psql","-U","gpadmin","-d","testDB","-f","/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-4.sql"])
    print res
    print str_style("query completed", fore = 'green')
    end = time.time()    
    print 'Task runs %0.2f seconds.' %(end - start)
    return res

def tenant8():
    start = time.time()
    print str_style('query start', fore = 'green')
	# query sql
    res = subprocess.check_output(["psql","-U","gpadmin","-d","testDB","-f","/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-4_1.sql"])
    print res
    print str_style("query completed", fore = 'green')
    end = time.time()    
    print 'Task runs %0.2f seconds.' %(end - start)
    return res

def tenant9():
    start = time.time()
    print str_style('query start', fore = 'green')
	# query sql
    res = subprocess.check_output(["psql","-U","gpadmin","-d","testDB","-f","/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-4_2.sql"])
    print res
    print str_style("query completed", fore = 'green')
    end = time.time()    
    print 'Task runs %0.2f seconds.' %(end - start)
    return res

if __name__ == "__main__":
    pool = multiprocessing.Pool(processes = 5)
    q = multiprocessing.Queue()

    pw = multiprocessing.Process(target=write_proc, args=(q,))
    pr = multiprocessing.Process(target=read_proc, args=(q,))

    # 启动子进程pw，写入:
    pw.start()
    # 启动子进程pr，读取:
    pr.start()
    # 等待pw结束:
    pw.join()
    # pr进程里是死循环，无法等待其结束，只能强行终止:
    pr.terminate()

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


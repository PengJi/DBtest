#coding: utf-8

import multiprocessing
import threading
import Queue
import time
import subprocess
from funs_shell import *

'''
线程类
'''

# 执行sql文件线程
class TranClass(threading.Thread):
    def __init__(self, queue, user, database,host, strsql):
        threading.Thread.__init__(self)
        self.user = user
        self.database = database
        self.host = host
        self.strsql = strsql
        self.res_queue = queue

    def run(self):
        res = subprocess.check_output(["psql","-U",self.user,"-d",self.database,"-h",self.host,"-f",self.strsql])
        #print res
        self.res_queue.put(self.strsql)
        self.res_queue.put(res)

# 执行sql命令线程
class TranClassComd(threading.Thread):
    def __init__(self, queue, user, database,host, str_query):
        threading.Thread.__init__(self)
        self.user = user
        self.database = database
        self.host = host
        self.str_query = str_query
        self.res_queue = queue

    def run(self):
        res = subprocess.check_output(["psql","-U",self.user,"-d",self.database,"-h",self.host,"-c",self.str_query])
        #print res
        self.res_queue.put(self.str_query)
        self.res_queue.put(res)

# 多进程查询sql语句
def exec_isolation(q,user,database,host,str_sql):
    # 启动collectl
    query_str = str_sql
    start_collectl(query_str)
    # 使系统达到稳定状态
    time.sleep(2)

    # 当前进程开始时间
    start_time = time.time()
    print str_sql,"start time is:", time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    res = subprocess.check_output(["psql","-U",user,"-d",database,"-h",host,"-f",str_sql])
    # 当前进程结束时间
    end_time = time.time()
    print str_sql,"end time is:", time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    query_time = str_sql +' duration %0.2f seconds.' %(end_time - start_time)

    # 执行时间
    q.put(query_time)
    # 查询语句
    q.put(str_sql)
    # 查询结果
    q.put(res)    

    # 使系统达到稳定状态
    time.sleep(2)
    # 结束collectl进程
    end_collectl()

# 多进程查询sql语句
def exec_concurrent(user,database,host,str_sql,m,r):
    # 启动collectl
    query_str = str_sql
    start_collectl(query_str)

    q = multiprocessing.Queue()

    # 每个查询执行5次
    for i in xrange(1,6):
        print str_sql,"第",i,"次开始"
        # 当前进程开始时间
        start_time = time.time()
        print str_sql,"start time is:", time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())

        res = subprocess.check_output(["psql","-U",user,"-d",database,"-h",host,"-f",str_sql])

        # 当前进程结束时间
        end_time = time.time()
        print str_sql,"end time is:", time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
        query_time = str_sql +' duration %0.2f seconds.' %(end_time - start_time)
        print str_sql,"第",i,"次结束"

        # 执行时间
        q.put(query_time)
        # 查询语句
        q.put(str_sql)
        # 查询结果
        q.put(res)
	time.sleep(0.2) # Just enough to let the Queue finish
    	
    print "exec_concurrent",str_sql,"执行结束"

    # 把每个查询组合的结果存入文件
    pre_path = "res_queries/mpl" + str(m) + "/"
    fp = open(pre_path+"mix"+str(r)+".txt","a")
    while not q.empty():
        fp.write(q.get())
    fp.close()

    # 清空队列
    q.close()
    
    # 结束collectl进程
    #end_collectl()

# 多进程查询sql语句,参数不同
# 利用queue进行进程间通信
def exec_concurrent_queue(q,user,database,host,str_sql,m,r):
    # 启动collectl
    query_str = str_sql
    start_collectl(query_str)

    # 每个查询执行5次
    for i in xrange(1,6):
        print str_sql,"第",i,"次开始"
        # 当前进程开始时间
        start_time = time.time()
        print str_sql,"start time is:", time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())

        res = subprocess.check_output(["psql","-U",user,"-d",database,"-h",host,"-f",str_sql])

        # 当前进程结束时间
        end_time = time.time()
        print str_sql,"end time is:", time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
        query_time = str_sql +' duration %0.2f seconds.' %(end_time - start_time)
        print str_sql,"第",i,"次结束"

        # 执行时间
        q.put(query_time)
        # 查询语句
        q.put(str_sql)
        # 查询结果
        q.put(res)

    print "exec_concurrent",str_sql,"执行结束"

    # 把每个查询组合的结果存入文件
    pre_path = "res_queries/mpl" + str(m) + "/"
    fp = open(pre_path+"mix"+str(r)+".txt","a")
    while not q.empty():
        fp.write(q.get())
    fp.close()

    # 清空队列
    q.close()
    
    # 结束collectl进程
    #end_collectl()

# 多进程查询sql语句
def exec_concurrent_once(q,user,database,host,str_sql):
    # 启动collectl
    query_str = str_sql
    start_collectl(query_str)

    # 每个查询执行5次
    # 当前进程开始时间
    start_time = time.time()
    print str_sql,"start time is:", time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())

    res = subprocess.check_output(["psql","-U",user,"-d",database,"-h",host,"-f",str_sql])

    # 当前进程结束时间
    end_time = time.time()
    print str_sql,"end time is:", time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    query_time = str_sql +' duration %0.2f seconds.' %(end_time - start_time)

    # 执行时间
    q.put(query_time)
    # 查询语句
    q.put(str_sql)
    # 查询结果
    q.put(res)

    print "exec_concurrent",str_sql,"执行结束"

    # 结束collectl进程
    #end_collectl()

# 扫描表进程,不需要 collectl 
def scan_sql(q,user,database,host,str_sql):
    # 当前进程开始时间
    start_time = time.time()
    print str_sql,"start time is:", time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())

    res = subprocess.check_output(["psql","-U",user,"-d",database,"-h",host,"-c",str_sql])

    # 当前进程结束时间
    end_time = time.time()
    print str_sql,"end time is:", time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    query_time = str_sql +' duration %0.2f seconds.' %(end_time - start_time)

    # 执行时间
    q.put(query_time)
    # 查询语句
    q.put(str_sql)
    # 查询结果
    q.put(res)


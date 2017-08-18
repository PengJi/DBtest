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
def exec_sql(q,user,database,host,str_sql):
    # 启动collectl
    res_path = "/home/gpdba/res_queries/"  # 暂时没用到
    query_str = str_sql
    start_collectl(query_str,res_path)

    # 当前进程开始时间
    start_time = time.time()
    print str_sql,"start time is:", time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())

    res = subprocess.check_output(["psql","-U",user,"-d",database,"-h",host,"-f",str_sql])

    # 当前进程结束时间
    end_time = time.time()
    print str_sql,"end time is:", time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    query_time = str_sql +' duration %0.2f seconds.' %(end_time - start_time)

    # 结束collectl进程
    end_collectl()

    # 执行时间
    q.put(query_time)
    # 查询语句
    q.put(str_sql)
    # 查询结果
    q.put(res)

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


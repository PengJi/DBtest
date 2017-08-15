#coding: utf-8

import multiprocessing
import threading
import Queue
import time
import subprocess

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
    res = subprocess.check_output(["psql","-U",user,"-d",database,"-h",host,"-f",str_sql])
    q.put(str_sql)
    q.put(res)

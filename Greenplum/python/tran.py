#coding: utf-8

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

# 批量创建角色线程
class RoleClass(threading.Thread):
    def __init__(self, user, database, host, tenant_name, strsql):
        threading.Thread.__init__(self)
        self.user = user
        self.database = database
        self.host = host
        self.tenant_name = tenant_name
        self.strsql = strsql
        
    def run(self):
        res = subprocess.check_output(["psql","-U",self.user,"-d",self.database,"-h",self.host,'--variable=role_name='+self.tenant_name,"-f",self.strsql])
        print res;

# 创建资源队列线程
class QueueClass(threading.Thread):
    def __init__(self, user, database, host, queue_name, strsql):
        threading.Thread.__init__(self)
        self.user = user
        self.database = database
        self.host = host
        self.queue_name = queue_name
        self.strsql = strsql
 
    def run(self):
        res = subprocess.check_output(["psql","-U",self.user,"-d",self.database,"-h",self.host,'--variable=queue_name='+self.queue_name,"-f",self.strsql])

# 创建schema线程
class SchemaClass(threading.Thread):
    def __init__(self, user, database, host, schema, strsql):
        threading.Thread.__init__(self)
        self.user = user
        self.database = database
        self.host = host
        self.schema = schema
        self.strsql = strsql

    def run(self):
        res = subprocess.check_output(["psql","-U",self.user,"-d",self.database,"-h",self.host,'--variable=schema_name='+self.schema,"-f",self.strsql])

# 测试sql
def test_tran():
    q = Queue.Queue()
    user = 'gpadmin'
    database = 'testDB'
    host = '192.168.100.78'
    strsql1 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-1.sql'
    strsql2 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-2.sql'
    strsql3 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-3.sql'
    p1 = TranClass(q, user, database,host,strsql1)
    p2 = TranClass(q, user, database,host,strsql2)
    p3 = TranClass(q, user, database,host,strsql3)
    p1.start()
    p2.start()
    p3.start()
    p1.join()
    p2.join()
    p3.join()
    while not q.empty():
        print q.get()

# 测试角色
def test_role():
    user = 'gpadmin'
    database = 'testDB'
    host = '192.168.100.78'
    strsql = '/home/gpadmin/DBtest/GPDB/python/queries/create_role.sql'
    threads = []
    
    for i in xrange(10,20):
        print 'test1'
        role = 'tenant' + str(i) 
        threads.append(RoleClass(user, database, host, role, strsql))
    
    for j in xrange(0,len(threads)):
        print 'test2'
        threads[j].start()
    
    for k in xrange(0,len(threads)):
        print 'test3'
        threads[k].join()

# 测试队列
def test_queue():
    user = 'gpadmin'
    database = 'testDB'
    host = '192.168.100.78'
    strsql = '/home/gpadmin/DBtest/GPDB/python/queries/create_queue.sql'
    threads = []
    
    for i in xrange(10,20):
        strqueue = 'myqueue' + str(i) 
        print strqueue
        threads.append(QueueClass(user, database, host, strqueue, strsql))
    
    for j in xrange(0,len(threads)):
        print 'test2'
        threads[j].start()
    
    for k in xrange(0,len(threads)):
        print 'test3'
        threads[k].join()

# 测试模式
def test_schema():
    user = 'gpadmin'
    database = 'testDB'
    host = '192.168.100.78'
    strsql = '/home/gpadmin/DBtest/GPDB/python/queries/create_schema.sql'
    threads = []
    
    for i in xrange(6,20):
        strschema = 'schema' + str(i) 
        print strschema
        threads.append(SchemaClass(user, database, host, strschema, strsql))

    for j in xrange(0,len(threads)):
        print 'test2'
        threads[j].start()
    
    for k in xrange(0,len(threads)):
        print 'test3'
        threads[k].join()

if __name__ == '__main__':
    print "tran main"
    #test_tran()
    #test_role()
    #test_queue()
    #test_schema()

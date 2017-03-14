#coding: utf-8

import threading
import Queue
import time
import subprocess

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
        self.res_queue.put(res)

# 创建角色
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
    role = 'tenant'
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

if __name__ == '__main__':
    #test_tran()
    test_role()

#coding: utf-8

import threading
import Queue
import time
import subprocess

class TranClass(threading.Thread):
    def __init__(self, user, database,host, strsql):
        threading.Thread.__init__(self)
        self.user = user
        self.database = database
        self.host = host
        self.strsql = strsql

    def run(self):
        res = subprocess.check_output(["psql","-U",self.user,"-d",self.database,"-h",self.host,"-f",self.strsql])
        print res

def test_fun():
    user = 'gpadmin'
    database = 'testDB'
    host = '192.168.100.78'
    strsql1 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-1.sql'
    strsql2 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-2.sql'
    strsql3 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-3.sql'
    p1 = TranClass(user,database,host,strsql1)
    p2 = TranClass(user,database,host,strsql2)
    p3 = TranClass(user,database,host,strsql3)
    p1.start()
    p2.start()
    p3.start()
    time.sleep(3)
    p1.join()
    p2.join()
    p3.join()

if __name__ == '__main__':
    test_fun()

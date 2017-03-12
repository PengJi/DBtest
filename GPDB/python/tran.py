#coding: utf-8

import threading
import Queue
import time
import subprocess

class TranClass(threading.Thread):
    def __init__(self, user, database, strsql):
        threading.Thread.__init__(self)
        self.user = user
        self.database = database
        self.strsql = strsql

    def run(self):
        res = subprocess.check_output(["psql","-U",self.user,"-d",self.database,"-f",self.strsql])
        print res

def test_fun():
    p1 = TranClass('gpadmin','testDB','/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-1.sql')
    p2 = TranClass('gpadmin','testDB','/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-2.sql')
    p3 = TranClass('gpadmin','testDB','/home/gpadmin/DBtest/GPDB/python/queries/photoobjall-3.sql')
    p1.start()
    p2.start()
    p3.start()
    time.sleep(3)
    p1.join()
    p2.join()
    p3.join()

if __name__ == '__main__':
    test_fun()

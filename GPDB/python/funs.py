#coding: utf-8

import subprocess
from tran import *
from shell_color import str_style

# 执行shell root命令
def sshclient(strcomd):
    hostname='192.168.100.78'
    username='root'
    password='jipeng1008'

    # paramiko.util.log_to_file('paramiko.log')  
    s = paramiko.SSHClient()

    s.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    s.connect(hostname = hostname,username=username, password=password)
    stdin, stdout, stderr = s.exec_command(strcomd)
    print stdout.read()
    s.close()

# 创建role
def create_role(start,end):
    user = 'gpadmin'
    database = 'testDB'
    host = '192.168.100.78'
    strsql = '/home/gpadmin/DBtest/GPDB/python/queries/create_role.sql'
    role = 'tenant'
    threads = []

    print str_style("creating role",fore="green")
    for i in xrange(start,end):
        role = 'tenant' + str(i)
        threads.append(RoleClass(user, database, host, role, strsql))

    for j in xrange(0,len(threads)):
        threads[j].start()

    for k in xrange(0,len(threads)):
        threads[k].join()
    print str_style("create role complete",fore="green")

# 创建queue
def create_queue(start,end):
    user = 'gpadmin'
    database = 'testDB'
    host = '192.168.100.78'
    strsql = '/home/gpadmin/DBtest/GPDB/python/queries/create_queue.sql'
    threads = []

    print str_style("creating queue",fore="green")
    for i in xrange(start,end):
        strqueue = 'myqueue' + str(i)
        threads.append(QueueClass(user, database, host, strqueue, strsql))

    for j in xrange(0,len(threads)):
        threads[j].start()

    for k in xrange(0,len(threads)):
        threads[k].join()
    print str_style("create queue complete",fore="green")

# 创建shema
def create_schema(start,end):
    user = 'gpadmin'
    database = 'testDB'
    host = '192.168.100.78'
    strsql = '/home/gpadmin/DBtest/GPDB/python/queries/create_schema.sql'
    threads = []
    
    print str_style("creating schema",fore="green")
    for i in xrange(start,end):
        strschema = 'schema' + str(i)
        threads.append(SchemaClass(user, database, host, strschema, strsql))

    for j in xrange(0,len(threads)):
        threads[j].start()
    
    for k in xrange(0,len(threads)):
        threads[k].join()
    print str_style("creating schema complete",fore="green")

if __name__ == '__main__':
    print "funs main"
    #create_role(20,100)
    #create_queue(6,100)
    #create_schema(20,100)

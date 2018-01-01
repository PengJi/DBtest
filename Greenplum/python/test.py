import subprocess
import time

def test():
    con = 'test'
    #subprocess.check_output(['echo',con,'>>','/home/gpadmin/DBtest/GPDB/python/run.log'],shell=True)
    subprocess.check_output(['echo 20 of process ' + con + ' time >> run.log'],shell=True)

if __name__ == '__main__':
    test()
    string = "tenant1"
    print string,"end time is:",time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    str_run = string+' task runs %0.2f seconds.' %(1342412412341)
    print str_run
    
    i = 10
    strsql1 = '/home/gpadmin/DBtest/GPDB/python/queries/photoobjall'+str(10)+'-1.sql'
    print strsql1

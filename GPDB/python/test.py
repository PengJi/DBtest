#coding: utf-8

import multiprocessing
import time

def func(msg):
    print "msg:", msg
    time.sleep(3)
    print "end"

if __name__ == "__main__":
    pool = multiprocessing.Pool(processes = 3)
    for i in xrange(4):
        msg = "hello %d" %(i)
        pool.apply_async(func, (msg, ))   #维持执行的进程总数为processes，当一个进程执行完毕后会添加新
的进程进去

    print "Mark~ Mark~ Mark~~~~~~~~~~~~~~~~~~~~~~"
    # 关闭pool，使其不再接受新的任务
    pool.close()
    # 主进程阻塞，等待子进程的退出 
    pool.join()
    #调用join之前，先调用close函数，否则会出错。执行完close后不会有新的进程加入到pool,join函数等待所有
子进程结束
    print "Sub-process(es) done."

#coding: utf-8

import multiprocessing
import time

def func(msg):
    print "msg:", msg
    time.sleep(3)
    print "end"

if __name__ == "__main__":
    pool = multiprocessing.Pool(processes = 3)

	# 测试pool
    for i in xrange(4):
        msg = "hello %d" %(i)
        pool.apply_async(func, (msg, ))  # 向pool中添加进程

    print "Mark~ Mark~ Mark~~~~~~~~~~~~~~~~~~~~~~"
    # 关闭pool，使其不再接受新的任务
    pool.close()
    # 主进程阻塞，等待子进程的退出 
    pool.join()
    
    print "Sub-process(es) done."

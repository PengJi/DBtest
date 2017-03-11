#coding: utf-8

import multiprocessing
import os
import time
import random
import subprocess

'''
测试多租户
'''
#   格式：\033[显示方式;前景色;背景色m
#   说明:
#
#   前景色            背景色            颜色
#   ---------------------------------------
#     30                40              黑色
#     31                41              红色
#     32                42              绿色
#     33                43              黃色
#     34                44              蓝色
#     35                45              紫红色
#     36                46              青蓝色
#     37                47              白色
#
#   显示方式           意义
#   -------------------------
#      0           终端默认设置
#      1             高亮显示
#      4            使用下划线
#      5              闪烁
#      7             反白显示
#      8              不可见
#
#   例子：
#   \033[1;31;40m    <!--1-高亮显示 31-前景色红色  40-背景色黑色-->
#   \033[0m          <!--采用终端默认设置，即取消颜色设置-->]]]
def str_style(string, mode = '', fore = '', back = ''):
	STYLE = {
        'fore':
        {   # 前景色
            'black'    : 30,   #  黑色
            'red'      : 31,   #  红色
            'green'    : 32,   #  绿色
            'yellow'   : 33,   #  黄色
            'blue'     : 34,   #  蓝色
            'purple'   : 35,   #  紫红色
            'cyan'     : 36,   #  青蓝色
            'white'    : 37,   #  白色
        },

        'back' :
        {   # 背景
            'black'     : 40,  #  黑色
            'red'       : 41,  #  红色
            'green'     : 42,  #  绿色
            'yellow'    : 43,  #  黄色
            'blue'      : 44,  #  蓝色
            'purple'    : 45,  #  紫红色
            'cyan'      : 46,  #  青蓝色
            'white'     : 47,  #  白色
        },

        'mode' :
        {   # 显示模式
            'mormal'    : 0,   #  终端默认设置
            'bold'      : 1,   #  高亮显示
            'underline' : 4,   #  使用下划线
            'blink'     : 5,   #  闪烁
            'invert'    : 7,   #  反白显示
            'hide'      : 8,   #  不可见
        },

        'default' :
        {
            'end' : 0,
        },
	}
	mode  = '%s' % STYLE['mode'][mode] if STYLE['mode'].has_key(mode) else ''
	fore  = '%s' % STYLE['fore'][fore] if STYLE['fore'].has_key(fore) else ''
	back  = '%s' % STYLE['back'][back] if STYLE['back'].has_key(back) else ''
	style = ';'.join([s for s in [mode, fore, back] if s])
	style = '\033[%sm' % style if style else ''
	end   = '\033[%sm' % STYLE['default']['end'] if style else ''
	return '%s%s%s' % (style, string, end)

def test_color( ):
    print str_style('正常显示')
    print ''

    print "测试显示模式"
    print str_style('高亮',   mode = 'bold'),
    print str_style('下划线', mode = 'underline'),
    print str_style('闪烁',   mode = 'blink'),
    print str_style('反白',   mode = 'invert'),
    print str_style('不可见', mode = 'hide')
    print ''

    print "测试前景色"
    print str_style('黑色',   fore = 'black'),
    print str_style('红色',   fore = 'red'),
    print str_style('绿色',   fore = 'green'),
    print str_style('黄色',   fore = 'yellow'),
    print str_style('蓝色',   fore = 'blue'),
    print str_style('紫红色', fore = 'purple'),
    print str_style('青蓝色', fore = 'cyan'),
    print str_style('白色',   fore = 'white')
    print ''

    print "测试背景色"
    print str_style('黑色',   back = 'black'),
    print str_style('红色',   back = 'red'),
    print str_style('绿色',   back = 'green'),
    print str_style('黄色',   back = 'yellow'),
    print str_style('蓝色',   back = 'blue'),
    print str_style('紫红色', back = 'purple'),
    print str_style('青蓝色', back = 'cyan'),
    print str_style('白色',   back = 'white')
    print ''

def func(msg):
	print "msg:", msg
	time.sleep(2)
	print "end"

def writer_proc(q):
    try:
        q.put(1, block = False)
    except:
        pass

def reader_proc(q):
    try:
        print q.get(block = False)
    except:
        pass

# queue写数据进程
def write_proc(q):
    for value in ['A', 'B', 'C']:
        print 'Put %s to queue...' % value
        q.put(value)
        time.sleep(random.random())

# queue读数据进程
def read_proc(q):
    while True:
        value = q.get(True)
        print 'Get %s from queue.' % value

def tenant1():
    start = time.time()
    print "start time is: ",time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    print str_style('query start', fore = 'green')

	# query sql
    res = subprocess.check_output(["psql","-U","gpadmin","-d","testDB","-f","/home/gpadmin/DBtest/GPDB/python/photoobjall-1.sql"])
    print res

    print str_style("query completed", fore = 'green')
    end = time.time()   

    print "end time is: ",time.strftime("%a %b %d %Y %H:%M:%S", time.localtime())
    print 'Task runs %0.2f seconds.' %(end - start)
    return res

def tenant2():
    start = time.time()
    print str_style('query start', fore = 'green')
	# query sql
    res = subprocess.check_output(["psql","-U","gpadmin","-d","testDB","-f","/home/gpadmin/DBtest/GPDB/python/photoobjall-1_1.sql"])
    print res
    print str_style("query completed", fore = 'green')
    end = time.time()    
    print 'Task runs %0.2f seconds.' %(end - start)
    return res

def tenant3():
    start = time.time()
    print str_style('query start', fore = 'green')
	# query sql
    res = subprocess.check_output(["psql","-U","gpadmin","-d","testDB","-f","/home/gpadmin/DBtest/GPDB/python/photoobjall-2.sql"])
    print res
    print str_style("query completed", fore = 'green')
    end = time.time()    
    print 'Task runs %0.2f seconds.' %(end - start)
    return res

def tenant4():
    start = time.time()
    print str_style('query start', fore = 'green')
	# query sql
    res = subprocess.check_output(["psql","-U","gpadmin","-d","testDB","-f","/home/gpadmin/DBtest/GPDB/python/photoobjall-2_1.sql"])
    print res
    print str_style("query completed", fore = 'green')
    end = time.time()    
    print 'Task runs %0.2f seconds.' %(end - start)
    return res

def tenant5():
    start = time.time()
    print str_style('query start', fore = 'green')
	# query sql
    res = subprocess.check_output(["psql","-U","gpadmin","-d","testDB","-f","/home/gpadmin/DBtest/GPDB/python/photoobjall-3.sql"])
    print res
    print str_style("query completed", fore = 'green')
    end = time.time()    
    print 'Task runs %0.2f seconds.' %(end - start)
    return res

def tenant6():
    start = time.time()
    print str_style('query start', fore = 'green')
	# query sql
    res = subprocess.check_output(["psql","-U","gpadmin","-d","testDB","-f","/home/gpadmin/DBtest/GPDB/python/photoobjall-3_1.sql"])
    print res
    print str_style("query completed", fore = 'green')
    end = time.time()    
    print 'Task runs %0.2f seconds.' %(end - start)
    return res

def tenant7():
    start = time.time()
    print str_style('query start', fore = 'green')
	# query sql
    res = subprocess.check_output(["psql","-U","gpadmin","-d","testDB","-f","/home/gpadmin/DBtest/GPDB/python/photoobjall-4.sql"])
    print res
    print str_style("query completed", fore = 'green')
    end = time.time()    
    print 'Task runs %0.2f seconds.' %(end - start)
    return res

def tenant8():
    start = time.time()
    print str_style('query start', fore = 'green')
	# query sql
    res = subprocess.check_output(["psql","-U","gpadmin","-d","testDB","-f","/home/gpadmin/DBtest/GPDB/python/photoobjall-4_1.sql"])
    print res
    print str_style("query completed", fore = 'green')
    end = time.time()    
    print 'Task runs %0.2f seconds.' %(end - start)
    return res

def tenant9():
    start = time.time()
    print str_style('query start', fore = 'green')
	# query sql
    res = subprocess.check_output(["psql","-U","gpadmin","-d","testDB","-f","/home/gpadmin/DBtest/GPDB/python/photoobjall-4_2.sql"])
    print res
    print str_style("query completed", fore = 'green')
    end = time.time()    
    print 'Task runs %0.2f seconds.' %(end - start)
    return res

if __name__ == "__main__":
    pool = multiprocessing.Pool(processes = 5)
    q = multiprocessing.Queue()

    pw = multiprocessing.Process(target=write_proc, args=(q,))
    pr = multiprocessing.Process(target=read_proc, args=(q,))

    # 启动子进程pw，写入:
    pw.start()
    # 启动子进程pr，读取:
    pr.start()
    # 等待pw结束:
    pw.join()
    # pr进程里是死循环，无法等待其结束，只能强行终止:
    pr.terminate()

    # 测试pool
    for i in xrange(5):
        msg = "hello %d" %(i)
        pool.apply_async(func, (msg, ))  # 向pool中添加进程

    print str_style("main process eecution", fore = "red") 
    pool.apply_async(tenant1, ())
    pool.apply_async(tenant2, ())
    pool.apply_async(tenant3, ())
    pool.apply_async(tenant4, ())
    pool.apply_async(tenant5, ())
    pool.apply_async(tenant6, ())
    pool.apply_async(tenant7, ())
    pool.apply_async(tenant8, ())
    pool.apply_async(tenant9, ())

    # 关闭pool，使其不再接受新的任务
    pool.close()
    # 主进程阻塞，等待子进程的退出 
    pool.join()
    
    print str_style("Sub-process(es) done.", fore = "red")


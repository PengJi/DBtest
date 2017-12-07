#coding: utf-8

import multiprocessing
import subprocess
from pyDOE import *
from numpy import *

from tran import *
from funs_shell import * 

'''
功能函数
'''

# 数据库连接信息
user = 'tenant'
database = 'testDB'
host = '192.168.100.78'
query_file_path = "/home/gpdba/DBtest/GPDB/tpcds/queries/"
scan_path = "/home/gpdba/DBtest/GPDB/tpcds/res_queries/scan/"
isolation_path = "/home/gpdba/DBtest/GPDB/tpcds/res_queries/isolation/"

# 查询映射
query_dict = {
1:17, 2:25, 3:26, 4:32, 5:33,
6:61, 7:62, 8:65, 9:71, 10:20,
11:8, 12:15, 13:18, 14:22, 15:27,
16:40, 17:46, 18:56, 19:60, 20:66,
21:70, 22:79, 23:82, 24:90
}

# 独立扫描表所用时间
# table_name 表名
# tm 迭代次数
def scan_table(table_name,tm):
    clear_cache()
    q = multiprocessing.Queue()

    query_sql = "set optimizer=off;explain analyze select * from " + table_name
    p = multiprocessing.Process(target=scan_sql,args=(q,user,database,host,query_sql,tm))
    p.start()
    p.join()

    fp = open(scan_path + table_name +".txt","a")
    while not q.empty():
        fp.write(q.get())
    fp.close()   

# 查询单独执行
# query_sql 要查询的语句，参数为: 17、20、25、26、32、33、61、62、65、71
# tm 迭代次数
def exec_isolation(query_sql,tm):
    # 清空缓存
    clear_cache()

    #q = multiprocessing.Queue()
    str_sql = query_file_path + "query"  + str(query_sql)+".sql"
    res_file = isolation_path + "query"  + str(query_sql)+ "."+ str(tm) + "." +"txt"

    p = multiprocessing.Process(target=func_isolation_rep,args=(user,database,host,str_sql,res_file,tm))
    p.start()
    p.join()
    
    '''
    # 保存结果
    fp = open(isolation_path + "query"+str(query_sql)+".txt","a")
    while not q.empty():
        fp.write(q.get())
    fp.close()
    q.close()
    '''
    
# 查询并发度为2
# tm 第几次
def mpl2(tm):
    print str_style("mpl2",fore="green")

	# 生成LHS
    #origin_mpl_2 = lhs(2,10)
    origin_mpl_2 = array([[0.3 , 0.5],
                    [0.9 , 0.7],
                    [0.4 , 1.0],
                    [0.8 , 0.1],
                    [0.2 , 0.8],
                    [0.1 , 0.4],
                    [0.7 , 0.2],
                    [1.0 , 0.6],
                    [0.5 , 0.9],
                    [0.6 , 0.3]])
    mpl_2 = ceil(origin_mpl_2*10)
    print mpl_2

    # 10个查询组合
    for r in range(10):
        clear_cache()
        #q = multiprocessing.Queue()

        print mpl_2[r]
        # 两个并行的不相等得查询
        if mpl_2[r][0] == mpl_2[r][1]:
            continue

        # primary query
        query_file1 = "query"+str(query_dict[int(mpl_2[r][0])])+".sql"
        query_file1 = query_file_path + query_file1
        print query_file1
        p1 = multiprocessing.Process(target=func_concurrent,args=(user,database,host,query_file1,2,r,tm))

        # concurrent query
        query_file2 = "query"+str(query_dict[int(mpl_2[r][1])])+".sql"
        query_file2 = query_file_path + query_file2
        print query_file2
        p2 = multiprocessing.Process(target=func_concurrent,args=(user,database,host,query_file2,2,r,tm))

        p1.start()
        p2.start()
        p1.join()
        p2.join()

        # 在主进程中结束所有collectl
        print "一个查询组合执行结束"
        end_collectl()
 
        '''
        # 由于容量的限制，下面代码移动到了func_concurrent
        # 把每个查询组合的结果存入文件
        subprocess.check_output(['echo -------------------------- >> run.log'],shell=True)
        fp = open("res_queries/mpl2/"+"mix"+str(r)+".txt","a")
        while not q.empty():
            fp.write(q.get())
        fp.close()

        # 清空队列
        q.close()
        '''

# 查询并发度为3
# tm 第几次迭代
def mpl3(tm):
    print str_style("mpl3",fore="green")

	# 生成LHS
    #origin_mpl_3 = lhs(3,10)
    #print origin_mpl_3
    #'''
    origin_mpl_3 = array([
        [ 0.97204296, 0.48445724, 0.16964192],
        [ 0.19993678, 0.34576865, 0.03754116],
        [ 0.09928598, 0.83103739, 0.45021525],
        [ 0.2701089,  0.79823359, 0.91254628],
        [ 0.42133176, 0.68151869, 0.57389982],
        [ 0.88131961, 0.97602772, 0.61408149],
        [ 0.75544795, 0.13762058, 0.30629768],
        [ 0.614892,   0.5498087,  0.85912425],
        [ 0.3701705,  0.03135862, 0.22716542],
        [ 0.52247938, 0.25298265, 0.76865154]
		])
    #'''
    #print origin_mpl_3
    mpl_3 = ceil(origin_mpl_3*10)
    print mpl_3

    for r in range(10):
        clear_cache()
        #q = multiprocessing.Queue()

        print mpl_3[r]

        # primary query
        query_file1 = "query"+str(query_dict[int(mpl_3[r][0])])+".sql"
        query_file1 = query_file_path + query_file1
        print query_file1
        p1 = multiprocessing.Process(target=func_concurrent,args=(user,database,host,query_file1,3,r,tm))

        # concurrent query
        query_file2 = "query"+str(query_dict[int(mpl_3[r][1])])+".sql"
        query_file2 = query_file_path + query_file2
        print query_file2
        p2 = multiprocessing.Process(target=func_concurrent,args=(user,database,host,query_file2,3,r,tm))

        # concurrent query
        query_file3 = "query"+str(query_dict[int(mpl_3[r][2])])+".sql"
        query_file3 = query_file_path + query_file3
        print query_file3
        p3 = multiprocessing.Process(target=func_concurrent,args=(user,database,host,query_file3,3,r,tm))

        # 并行执行
        p1.start()
        p2.start()
        p3.start()
        p1.join()
        p2.join()
        p3.join()

        # 在主进程中结束所有collectl
        print "一个查询组合执行结束"
        end_collectl()


# 查询并发度为4
# tm 第几次迭代
def mpl4(tm):
    print str_style("mpl2",fore="green")

	# 生成LHS
    #origin_mpl_4 = lhs(4,25)
    origin_mpl_4 = array([
        [  0.9,   0.7,   0.3,   0.4],
        [  0.8,   0.9,   0.1,   1.0],
        [  0.5,   0.2,   0.9,   0.7],
        [  0.7,   0.9,   1.0,   0.8],
        [  0.1,   0.2,   0.4,   0.9],
        [  0.2,   0.3,   0.5,   1.0],
        [  0.4,   0.3,   0.2,   0.7],
        [  0.3,   0.5,   0.8,   0.6],
        [  0.6,   1.0,   0.7,   0.5],
        [  1.0,   0.7,   0.8,   0.1]
    ])
    mpl_4 = ceil(origin_mpl_4*10)
    print mpl_4

    for r in range(10):
        clear_cache()
        #q = multiprocessing.Queue()

        print mpl_4[r]

        # primary query
        query_file1 = "query"+str(query_dict[int(mpl_4[r][0])])+".sql"
        query_file1 = query_file_path + query_file1
        print query_file1
        p1 = multiprocessing.Process(target=func_concurrent,args=(user,database,host,query_file1,4,r,tm))

        # concurrent query
        query_file2 = "query"+str(query_dict[int(mpl_4[r][1])])+".sql"
        query_file2 = query_file_path + query_file2
        print query_file2
        p2 = multiprocessing.Process(target=func_concurrent,args=(user,database,host,query_file2,4,r,tm))

        # concurrent query
        query_file3 = "query"+str(query_dict[int(mpl_4[r][2])])+".sql"
        query_file3 = query_file_path + query_file3
        print query_file3
        p3 = multiprocessing.Process(target=func_concurrent,args=(user,database,host,query_file3,4,r,tm))

        # concurrent query
        query_file4 = "query"+str(query_dict[int(mpl_4[r][3])])+".sql"
        query_file4 = query_file_path + query_file4
        print query_file4
        p4 = multiprocessing.Process(target=func_concurrent,args=(user,database,host,query_file4,4,r,tm))

        # 并行执行
        p1.start()
        p2.start()
        p3.start()
        p4.start()
        p1.join()
        p2.join()
        p3.join()
        p4.join()
 
        # 在主进程中结束所有collectl
        print "一个查询组合执行结束"
        end_collectl()
        

# 查询并发度为5
# tm 第几次迭代
def mpl5(tm):
    print str_style("mpl5",fore="green")

	# 生成LHS
    #origin_mpl_5 = lhs(5,25)
    origin_mpl_5 = array([
        [  1.0,   0.7,   0.9,   0.3,   0.8],
        [  0.9,   0.6,   0.3,   0.7,   0.5],
        [  0.8,   0.4,   1.0,   0.2,   0.1],
        [  0.1,   0.2,   0.6,   0.8,   0.7],
        [  0.5,   0.1,   0.8,   0.4,   1.0],
        [  0.4,   0.3,   0.8,   0.5,   0.2],
        [  0.7,   0.8,   0.3,   1.0,   0.6],
        [  0.3,   0.5,   0.1,   0.9,   0.4],
        [  0.6,   0.7,   0.9,   0.1,   0.3],
        [  0.2,   0.5,   0.4,   0.9,   0.3]
    ])
    mpl_5 = ceil(origin_mpl_5*10)
    print mpl_5

    for r in range(10):
        clear_cache()
        q = multiprocessing.Queue()

        print mpl_5[r]

        # primary query
        query_file1 = "query"+str(query_dict[int(mpl_5[r][0])])+".sql"
        query_file1 = query_file_path + query_file1
        print query_file1
        p1 = multiprocessing.Process(target=func_concurrent,args=(user,database,host,query_file1,5,r,tm))

        # concurrent query
        query_file2 = "query"+str(query_dict[int(mpl_5[r][1])])+".sql"
        query_file2 = query_file_path + query_file2
        print query_file2
        p2 = multiprocessing.Process(target=func_concurrent,args=(user,database,host,query_file2,5,r,tm))

        # concurrent query
        query_file3 = "query"+str(query_dict[int(mpl_5[r][2])])+".sql"
        query_file3 = query_file_path + query_file3
        print query_file3
        p3 = multiprocessing.Process(target=func_concurrent,args=(user,database,host,query_file3,5,r,tm))

        # concurrent query
        query_file4 = "query"+str(query_dict[int(mpl_5[r][3])])+".sql"
        query_file4 = query_file_path + query_file4
        print query_file4
        p4 = multiprocessing.Process(target=func_concurrent,args=(user,database,host,query_file4,5,r,tm))

        # concurrent query
        query_file5 = "query"+str(query_dict[int(mpl_5[r][4])])+".sql"
        query_file5 = query_file_path + query_file5
        print query_file5
        p5 = multiprocessing.Process(target=func_concurrent,args=(user,database,host,query_file5,5,r,tm))

        # 并行执行
        p1.start()
        p2.start()
        p3.start()
        p4.start()
        p5.start()
        p1.join()
        p2.join()
        p3.join()
        p4.join()
        p5.join()

        # 在主进程中结束所有collectl
        print "一个查询组合执行结束"
        end_collectl()
        

if __name__ == '__main__':
    print "funs.py"

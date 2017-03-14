#coding: utf-8

import subprocess
import os
from tran import *

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

# 删除目录下所有文件
def delete_file_folder(src):
    if os.path.isfile(src):
        try:
            os.remove(src)
        except:
            pass
    elif os.path.isdir(src):
        for item in os.listdir(src):
            itemsrc=os.path.join(src,item)
            delete_file_folder(itemsrc)

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

if __name__ == '__main__':
    print "funs main"
    test_color()
    #create_role(20,100)
    #create_queue(6,100)
    #create_schema(20,100)

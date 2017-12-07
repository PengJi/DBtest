#coding: utf-8

import paramiko

# 执行shell root命令
def sshclient(host,user,passwd,strcomd):
    str_put = host+strcomd
    print str_style(str_put, fore = 'green')
    # paramiko.util.log_to_file('paramiko.log')  
    s = paramiko.SSHClient()
    s.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    s.connect(hostname = host,username=user, password=passwd)
    stdin, stdout, stderr = s.exec_command(strcomd)
    print stdout.read()
    s.close()

# 启动collectl
# m 并发度，0:扫描表；1:单独执行查询；2,3,4,5:并发度为2,3,4,5
def start_collectl(query_str,m,tm):
    user = "gpdba"
    passwd = "gpdba"
    query = "collectl -sDN --dskfilt ^dm --netfilt ens -oT -P >>" + query_str + "." + str(m) + str(tm)  +".txt &"

    sshclient('JPDB2',user,passwd,query)
    sshclient('node1',user,passwd,query)
    sshclient('node2',user,passwd,query)
    sshclient('node3',user,passwd,query)
    #sshclient('node4',user,passwd,strcmd)
    sshclient('node5',user,passwd,query)
    #sshclient('node6',user,passwd,strcmd)

# 结束collectl进程
def end_collectl():
    user = "gpdba"
    passwd = "gpdba"
    comd = "pgrep collectl | xargs kill -9"
    
    sshclient('JPDB2',user,passwd,comd)
    sshclient('node1',user,passwd,comd)
    sshclient('node2',user,passwd,comd)
    sshclient('node3',user,passwd,comd)
    #sshclient('node4',user,passwd,strcmd)
    sshclient('node5',user,passwd,comd)
    #sshclient('node6',user,passwd,strcmd)

# 清空集群中所有节点的缓存
def clear_cache():
    user = 'root'
    passwd = 'jipeng1008'
    strcmd = 'sync; echo 1 > /proc/sys/vm/drop_caches'
    print str_style('clear caches', fore = 'green')
    sshclient('JPDB2',user,passwd,strcmd)
    sshclient('node1',user,passwd,strcmd)
    sshclient('node2',user,passwd,strcmd)
    sshclient('node3',user,passwd,strcmd)
    #sshclient('node4',user,passwd,strcmd)
    sshclient('node5',user,passwd,strcmd)
    #sshclient('node6',user,passwd,strcmd)

# 修改显示颜色
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

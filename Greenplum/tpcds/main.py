#coding: utf-8

from funs import *

if __name__ == '__main__':
    print str_style("[main start]",fore="yellow")

    for i in xrange(1,6):
        # 扫描表
        #'''
        scan_table('date_dim',i)
        scan_table('item',i)
        scan_table('ship_mode',i)
        scan_table('catalog_sales',i)
        scan_table('web_site',i)
        scan_table('web_sales',i)
        scan_table('store',i)
        scan_table('store_sales',i)
        scan_table('store_returns',i)
        scan_table('customer',i)
        scan_table('customer_demographics',i)
        scan_table('customer_address',i)
        scan_table('promotion',i)
        scan_table('warehouse',i)
	    #'''

        '''
        scan_table('inventory')
        scan_table('catalog_returns')
        scan_table('time_dim')
        scan_table('household_demographics')
        scan_table('web_page')
        '''

        # 单独执行查询
        # 可选参数：17、20、25、26、32、33、61、62、65、71
        #'''
        exec_isolation(17,i)
        exec_isolation(20,i)
        exec_isolation(25,i)
        exec_isolation(26,i)
        exec_isolation(32,i)
        exec_isolation(33,i)
        exec_isolation(61,i)
        exec_isolation(62,i)
        exec_isolation(65,i)
        exec_isolation(71,i)
        #'''
        # 对于其他查询
        '''
        exec_isolation(2)
        exec_isolation(8)
        exec_isolation(15)
        exec_isolation(18)
        exec_isolation(22)
        exec_isolation(27)
        exec_isolation(40)
        exec_isolation(46)
        exec_isolation(56)
        exec_isolation(60)
        exec_isolation(66)
        exec_isolation(70)
        exec_isolation(79)
        exec_isolation(82)
        exec_isolation(90)
        '''

        #'''
        mpl2(i)

        mpl3(i)

        mpl4(i)

        mpl5(i)
        #'''

    print str_style("[main end]",fore="yellow")

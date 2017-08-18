#coding: utf-8

from funs import *

if __name__ == '__main__':
    print str_style("[main start]",fore="yellow")

    # 扫描表
    clear_cache()
    #'''
    scan_table('date_dim')
    scan_table('item')
    scan_table('ship_mode')
    scan_table('catalog_sales')
    scan_table('web_site')
    scan_table('web_sales')
    scan_table('store')
    scan_table('store_sales')
    scan_table('store_returns')
    scan_table('customer')
    scan_table('customer_demographics')
    scan_table('customer_address')
    scan_table('promotion')
    scan_table('warehouse')
    #'''

    # 可选参数：17、20、25、26、32、33、61、62、65、71
    '''
    subprocess.check_output(['echo ============================== >> run.log'],shell=True)
    exec_isolation(17)
    exec_isolation(20)
    exec_isolation(25)
    exec_isolation(26)
    exec_isolation(32)
    exec_isolation(33)
    exec_isolation(61)
    exec_isolation(62)
    exec_isolation(65)
    exec_isolation(71)
    '''
    #subprocess.check_output(['echo =============================== >> run.log'],shell=True)
    #mpl2()

    #subprocess.check_output(['echo =============================== >> run.log'],shell=True)
    #mpl3()

    #subprocess.check_output(['echo =============================== >> run.log'],shell=True)
    #mpl4()

    #subprocess.check_output(['echo =============================== >> run.log'],shell=True)
    #mpl5()

    print str_style("[main end]",fore="yellow")

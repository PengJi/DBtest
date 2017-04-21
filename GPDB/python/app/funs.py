from pgdb import connect

def conn(hostaddr = '192.168.100.78',dbname = 'testDB', username = 'gpadmin', passwd = 'gpadmin'):
    hoststr = hostaddr + ':5432'
    obj = connect(database=dbname, host=hoststr ,user=username, password=passwd)
    return obj

def test_insert():
    con = conn()
    cursor = con.cursor()
    cursor.execute("create table fruits(id serial primary key, name varchar)")
    cursor.execute("insert into fruits (name) values ('apple')")
    # pass parameters
    cursor.execute("insert into fruits (name) values (%s)", ('banana',))
    more_fruits = 'cherimaya durian eggfruit fig grapefruit'.split()
    parameters = [(name,) for name in more_fruits]
    cursor.executemany("insert into fruits (name) values (%s)", parameters)

    con.commit()
    cursor.close()
    con.close()

def test_select():
    con = conn()
    cursor = con.cursor()
    cursor.execute('select * from fruits where id=1')
    print cursor.fetchone()

    cursor.execute('select * from fruits')
    print cursor.fetchall()

    cursor.execute('select * from fruits')
    print cursor.fetchmany(2)

    cursor.close()
    con.close()

if __name__ == '__main__':
    test_select()

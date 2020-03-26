from flask import Flask, request, jsonify
import sqlite3
from flask import g
from flask_cors import CORS
import base64

app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False
CORS(app, supports_credentials=True)
DATABASE = 'database.db'

def make_dicts(cursor, row):
    return dict((cursor.description[idx][0], value)
                for idx, value in enumerate(row))

def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = sqlite3.connect(DATABASE)
        # db.row_factory = make_dicts
        db.row_factory = sqlite3.Row
    return db

def query_db(query, args=(), one=False):
    cur = get_db().execute(query, args)
    rv = cur.fetchall()
    cur.close()
    return (rv[0] if rv else None) if one else rv

def delete_insert_db(sql, args=()):
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = sqlite3.connect(DATABASE)
    cursor = db.cursor()
    try:
        cursor.execute(sql, args)
        db.commit()
        return ''
    except:
        return 'False'

def borrowListById(stu_id):
    sql='select * from StuBorrow where stu_id=?'
    borrowlist = {}
    borrowlist['book_id'] = []
    borrowlist['bor_date'] = []
    for student in query_db(sql,(stu_id,)):
        borrowlist['book_id'].append(student['book_id'])
        borrowlist['bor_date'].append(student['bor_date'])
    return borrowlist

@app.route('/login',methods=['GET','POST'])
def login():
    stu_id = request.args.get('stu_id')
    stu_pwd = request.args.get('stu_pwd')
    stu_pwd = stu_pwd + stu_id  # salt
    b64_pwd = base64.b64encode(stu_pwd.encode())
    for student in query_db('select * from Student'):
        if student['stu_id']==stu_id and student['stu_pwd']==b64_pwd:
            return ''
        elif student['stu_id']==stu_id and student['stu_pwd']!=b64_pwd:
            print("密码不正确")
            return '密码不正确'
    print("学号未注册")
    return '学号未注册'

@app.route('/signup',methods=['GET','POST'])
def signup():
    stu_id = request.args.get('stu_id')
    stu_pwd = request.args.get('stu_pwd')
    stu_pwd = stu_pwd + stu_id  # salt
    b64_pwd = base64.b64encode(stu_pwd.encode())
    stu_name = request.args.get('stu_name')
    sql = 'INSERT into Student values(?,?,?);'
    print("注册")
    return delete_insert_db(sql, (stu_id,stu_name,b64_pwd,))

@app.route('/borrowlist',methods=['GET','POST'])
def borrowList():
    stu_id = request.args.get('stu_id')
    sql='SELECT * from StuBorrow where stu_id=? order by bor_date asc'
    borrowlist = {}
    borrowlist['book_id'] = []
    borrowlist['bor_date'] = []
    for student in query_db(sql,(stu_id,)):
        borrowlist['book_id'].append(student['book_id'])
        borrowlist['bor_date'].append(student['bor_date'])
    return borrowlist

@app.route('/getBookInfo',methods=['GET','POST'])
def getBookInfo():
    book_id = request.args.get('book_id')
    mode = request.args.get('mode')
    bookInfo = {}
    bookInfo['book_id']=[]
    bookInfo['book_name']=[]
    bookInfo['author']=[]
    bookInfo['translator']=[]
    bookInfo['cover_url']=[]

    if mode=='detailed':
        bookInfo['basic_info']=[]
        bookInfo['main_content']=[]
        bookInfo['author_info']=[]
        bookInfo['stock']=[]

    sql='select * from BookInventory where book_id=?'
    for book in query_db(sql,(book_id,)):
        bookInfo['book_id']=book['book_id']
        bookInfo['book_name']=book['book_name']
        bookInfo['author']=book['author']
        bookInfo['translator']=book['translator']
        bookInfo['cover_url']=book['cover_url']
        # print("book url = "+str(book['cover_url']))
        if mode=='detailed':
            bookInfo['basic_info']=book['basic_info']
            bookInfo['main_content']=book['main_content']
            bookInfo['author_info']=book['author_info']
            bookInfo['stock']=book['stock']
        return bookInfo
    return 'bug'

@app.route('/returnBook', methods=['GET','POST'])
def returnBook():  # 还书
    book_id = request.args.get('book_id')
    stu_id = request.args.get('stu_id')
    sql = "DELETE from StuBorrow where (stu_id=? and book_id=?);"
    return delete_insert_db(sql, (stu_id, book_id,))

@app.route('/borrowBook', methods=['GET','POST'])
def borrowBook():
    book_id = request.args.get('book_id')
    stu_id = request.args.get('stu_id')
    bor_date = request.args.get('bor_date')
    sql = "INSERT into StuBorrow values(?,?,?);"
    return delete_insert_db(sql, (book_id, stu_id, bor_date,))

@app.route('/ifBorrow',  methods=['GET','POST'])
def ifBorrow():
    book_id = request.args.get('book_id')
    stu_id = request.args.get('stu_id')
    sql = "SELECT bor_date from StuBorrow where (stu_id=? and book_id=?)"
    for book in query_db(sql,(stu_id, book_id,)):
        return book['bor_date']
    return 'False'

@app.route('/searchResult',methods=['GET','POST'])
def searchResult():
    keyword = request.args.get('keyword')
    mode = request.args.get('mode')
    bookInfo = {}
    bookInfo['book_id']=[]
    bookInfo['book_name']=[]
    bookInfo['author']=[]
    bookInfo['translator']=[]
    bookInfo['cover_url']=[]

    if mode=='detailed':
        bookInfo['basic_info']=[]
        bookInfo['main_content']=[]
        bookInfo['author_info']=[]
        bookInfo['stock']=[]

    sql = "SELECT * from BookInventory where book_name like '%%%s%%'" % keyword
    for book in query_db(sql):
        bookInfo['book_id'].append(book['book_id'])
        bookInfo['book_name'].append(book['book_name'])
        bookInfo['author'].append(book['author'])
        bookInfo['translator'].append(book['translator'])
        bookInfo['cover_url'].append(book['cover_url'])
        if mode=='detailed':
            bookInfo['basic_info'].append(book['basic_info'])
            bookInfo['main_content'].append(book['main_content'])
            bookInfo['author_info'].append(book['author_info'])
            bookInfo['stock'].append(book['stock'])
    # print(bookInfo)
    return bookInfo

@app.teardown_appcontext
def close_connection(exception):
    db = getattr(g, '_database', None)
    if db is not None:
        db.close()

if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=9000, )



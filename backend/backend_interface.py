from flask import Flask, jsonify
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

@app.route('/login',methods=['GET','POST'])
def login():
    stu_id = request.args.get('stu_id')
    stu_pwd = request.args.get('stu_pwd')
    b64_pwd = base64.b64encode(stu_pwd.encode())
    for student in query_db('select * from Student'):
        if student['stu_id']==stu_id and student['stu_pwd']==stu_pwd:
            return borrowList(stu_id)
    return 'not okay'

def borrowList(stu_id):
    sql='select * from StuBorrow where stu_id=?'
    borrowlist = {}
    borrowlist['book_id'] = []
    borrowlist['bro_date'] = []
    for student in query_db(sql,(stu_id,)):
        borrowlist['book_id'].append(student['book_id'])
        borrowlist['bro_date'].append(student['bro_date'])
    return borrowlist


	# list_t = {}
	# list_t['id']=[]
	# list_t['name']=[]
	# list_t['pwd']=[]
	# for user in query_db('select * from Student'):
	#     print(user['stu_id'],user['stu_name'],user['stu_pwd'])
	#     list_t['id'].append(user['stu_id'])
	#     list_t['name'].append(user['stu_name'])
	#     list_t['pwd'].append(user['stu_pwd'])

	# return jsonify(list_t)


@app.teardown_appcontext
def close_connection(exception):
    db = getattr(g, '_database', None)
    if db is not None:
        db.close()

if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=9000, )



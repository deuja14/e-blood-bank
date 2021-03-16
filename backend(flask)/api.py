from flask import Flask, request, jsonify
import sqlite3

app = Flask(__name__)
app.config["DEBUG"] = True 
# debugging is made true

#for making the dictionary format of data from query
def dict_factory(cursor, row):
    d = {}
    for idx, col in enumerate(cursor.description):
        d[col[0]] = row[idx]
    return d

#for database connection
def db_connection():
    conn = None
    try:
        path=r"D:\e-blood-bank\database\bloodbank.db"
        # r represents raw string in python
        conn=sqlite3.connect(path)
    except sqlite3.error as e:
        print(e)
    return conn

@app.route('/api/v1', methods=['GET'])
def login():
    conn = db_connection()
    conn.row_factory = dict_factory
    cursor = conn.cursor()

    if request.method == 'GET':
        userlist = conn.execute("SELECT * FROM users;").fetchall()
        # cursor = conn.execute("SELECT * FROM users;")
        # users = [
        #     dict(Address=row[0], Client_id=row[1], Contact_no=row[2], First_name=row[3], Last_name=row[4], Password=row[5], Username=row[6])
        #     for row in cursor.fetchall()
        # ]
        # if users is not None:
        #     return jsonify(users)
        return jsonify(userlist)
     
@app.route('/', methods=['POST'])
def post():
    conn = db_connection()
    # conn.row_factory = dict_factory
    cursor = conn.cursor()
    if request.method == 'POST':
        # First_name = request.args.get('a')
        # Last_name = request.args.get('b')
        # Contact_no = request.args.get('c')
        # Address = request.args.get('d')
        # Username = request.args.get('e')
        # Password = request.args.get('f')

        data = request.get_json()
        First_name = data['First_name']
        Last_name = data['Last_name']
        Contact_no = data['Contact_no']
        Address = data['Address']
        Username = data['Username']
        Password = data['Password']
        sql = """INSERT INTO "main"."users"
                ("First_name", "Last_name", "Contact_no", "Address", "Username", "Password")
                VALUES (?, ?, ?, ?, ?, ?);"""
        cursor = cursor.execute(sql, (First_name, Last_name, Contact_no, Address, Username, Password))
        conn.commit()
        return f"Book with the id: 0 created successfully", 201

@app.route('/login', methods=['POST'])
def login_pressed():
    data = request.get_json()

    print(data)
    return jsonify(data),500
    # test = "sanam"
    # return f"this is return {test} from the api side",500

if __name__ == '__main__':
    app.run()
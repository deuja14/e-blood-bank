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
        path=r"D:\E-BloodBank\e-blood-bank\database\bloodbank1.db"
        # r represents raw string in python
        conn=sqlite3.connect(path)
    except sqlite3.error as e:
        print(e)
    return conn

@app.errorhandler(404)
def page_not_found(e):
    return "<h1>404</h1><p>The resource could not be found.</p>", e

@app.route('/signup', methods=['POST'])
def post():
    conn = db_connection()
    cursor = conn.cursor()

    if request.method == 'POST':
        data = request.get_json()
        Name = data['name']
        Phone = data['phone']
        Address = data['address']
        Age = data['age']
        User_type = data['user_type']
        Gender = data['gender']
        Blood_type = data['bgroup']
        Latitude = data['latitude']
        Longitude = data['longitude']
        Password = data['password']
        Email = data['email']
        
        print(data)

        sql = """INSERT INTO users
                ("Name", "Phone", "Age", "Gender", "Address", "Latitude", "Longitude", "Blood_type", "Email", "User_type", "Password")
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"""

        cursor = cursor.execute(sql, (Name,Phone,Age,Gender,Address,Latitude,Longitude,Blood_type,Email,User_type,Password))
        conn.commit()
        conn.close()

        return f"Book with the id: 0 created successfully", 201



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
    conn.commit()
    conn.close()
     


@app.route('/login', methods=['POST'])
def login_pressed():
    conn = db_connection()
    conn.row_factory = dict_factory
    cursor = conn.cursor()
    data = request.get_json()
    
    uname=data['username']
    pwd=data['password']

    sql = """SELECT * FROM users WHERE"""
    to_filter = []
    if uname:
        sql += ' Phone=? AND'
        to_filter.append(uname)
    if pwd:
        sql += ' Password=? AND'
        to_filter.append(pwd)

    # if not(uname or pwd):
    #     return page_not_found(404)

    sql = sql[:-4] + ';'

    results = cursor.execute(sql,to_filter).fetchall()

    if not results:
        return page_not_found(404)

    print(type(results))
    return jsonify(results),500
    # test = "sanam"
    # return f"this is return {test} from the api side",500

if __name__ == '__main__':
    app.run()
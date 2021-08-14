from flask import Flask, request, jsonify
import sqlite3
import requests
from flask_bcrypt import Bcrypt
from datetime import datetime



app = Flask(__name__)
app.config["DEBUG"] = True 
bcrypt = Bcrypt(app)

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
        path=r"D:\E-BloodBank\e-blood-bank\database\test1.db"
        # r represents raw string in python
        conn=sqlite3.connect(path)
    except sqlite3.error as e:
        print(e)
    return conn

@app.errorhandler(404)
def page_not_found(e):
    return "<h1>404</h1><p>The resource could not be found.</p>", e

@app.route('/apositive',methods=['GET'])
def apos():
    conn = db_connection()
    conn.row_factory = dict_factory
    cursor = conn.cursor()
    

    if request.method == 'GET':
        userlist = cursor.execute("SELECT * FROM user WHERE bloodGroup='A+';").fetchall()
        if not userlist:
            return page_not_found(404)

        return jsonify(userlist),200
    conn.commit()
    conn.close()    

@app.route('/distancematrix', methods=['POST'],)
def distancematrix():
    conn = db_connection()
    conn.row_factory = dict_factory
    cursor = conn.cursor()

    data =  request.get_json()
    latitude=data['latitude']
    longitude=data['longitude']
    print(latitude,longitude)
    userlist = cursor.execute("SELECT * FROM user WHERE bloodGroup='AB-';").fetchall()
    if not userlist:
        return page_not_found(404)

    conn.commit()
    conn.close()
    print(userlist)
    return jsonify(userlist),200



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
        hashed_password = bcrypt.generate_password_hash(Password).decode('utf-8')
        pwd=str(hashed_password)
        Email = data['email']
        dateRegistered= datetime.utcnow
        role="USER"
        
        print(data)

        sql = """INSERT INTO user
                ("role","fullname", "phoneNumber", "age", "gender", "address", "lat", "lng", "bloodGroup", "email", "userType", "password", "dateRegistered")
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"""

        cursor = cursor.execute(sql, (role,Name,Phone,Age,Gender,Address,Latitude,Longitude,Blood_type,Email,User_type,pwd,dateRegistered))
        conn.commit()
        conn.close()

        return f"Book with the id: 0 created successfully", 201



@app.route('/api/markers', methods=['GET'])
def markers():
    conn = db_connection()
    conn.row_factory = dict_factory
    cursor = conn.cursor()
    

    if request.method == 'GET':
        userlist = cursor.execute("SELECT * FROM user WHERE bloodGroup='A+' OR bloodGroup='A +ve';").fetchall()
        if not userlist:
            return page_not_found(404)
        na=userlist[0]['fullName']
        print(type(na))
        return jsonify(userlist),200
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
    hashed_password = bcrypt.generate_password_hash(pwd).decode('utf-8')

    sql = """SELECT * FROM user WHERE"""
    to_filter = []
    if uname:
        sql += ' Phone=? AND'
        to_filter.append(uname)
    if hashed_password:
        sql += ' Password=? AND'
        to_filter.append(hashed_password)

    # if not(uname or pwd):
    #     return page_not_found(404)

    sql = sql[:-4] + ';'

    results = cursor.execute(sql,to_filter).fetchall()

    password = results[0]['password']
    print(password)
    
    # if bcrypt.check_password_hash(hashed_password, password):
    #     print(type(results))
    #     return jsonify(results),202

    if not results:
        return page_not_found(404)

    print(type(results))
    return jsonify(results),202
    # test = "sanam"
    # return f"this is return {test} from the api side",500


if __name__ == '__main__':
    app.run()
from functools import wraps
from flask import Flask, render_template, jsonify, request, redirect, url_for
from flask_login import login_user, current_user, logout_user, login_required
import sqlite3
from sqlalchemy import or_
from ebloodbank import app, db, bcrypt
from ebloodbank.models import User, Newsletter, Notice, BloodBank, BloodRequest
from ebloodbank.forms import RegistrationForm, LoginForm, NewsletterForm, NoticeForm, BloodBankForm, AmbulanceForm, BloodRequestForm
# from flask_admin import Admin

db.create_all()

admin_created = User.query.filter_by(role = "ADMIN").first()
if admin_created is None:
	admin_password = bcrypt.generate_password_hash("1432117").decode('utf-8')
	user = User(role="ADMIN", fullName='Dipesh Deuja', email='deujadipesh1407@gmail.com', phoneNumber='9863039154', address='Suryabinayak-12', lat='27.6201', lng='85.6116', bloodGroup='O +ve', gender='Male', age='23', userType="Both", password=admin_password)
	db.session.add(user)
	db.session.commit()

def restricted(access_level):
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            if not current_user.role == access_level:
                return redirect(url_for('admin_access'))
            return func(*args, **kwargs)
        return wrapper
    return decorator

@app.route("/admin-access")
def admin_access():
	return render_template(
		'/ebloodbank/admin-access.djhtml'
		)

@app.route("/", methods=['GET','POST'])
# @login_required
def home():
	form = NewsletterForm()
	if request.method == 'POST':
		# if form.validate_on_submit():
		email = Newsletter(email=form.email.data)
		db.session.add(email)
		db.session.commit()
		print('success')
		# else:
			# print('failed')
	return render_template(
		'/ebloodbank/home.djhtml', form=form
		)

@app.route("/register", methods=['GET','POST'])
def user_registration():
	form = RegistrationForm()
	if request.method == 'POST':
		if form.validate_on_submit():
			hashed_password = bcrypt.generate_password_hash(form.password.data).decode('utf-8')
			user = User(fullName=form.fullName.data, email=form.email.data, phoneNumber=form.phoneNumber.data, address=form.address.data, bloodGroup=form.bloodGroup.data, gender=form.gender.data, age=form.age.data, userType=form.userType.data, password=hashed_password)
			db.session.add(user)
			db.session.commit()
			print('success')
		else:
			print('failed')
	return render_template(
		'/ebloodbank/dashboard/register.djhtml', form=form
		)

@app.route("/login", methods=['GET','POST'])
def user_login():
	form = LoginForm()
	if request.method == 'POST':
		if form.validate_on_submit():
			user = User.query.filter_by(phoneNumber = form.phoneNumber.data).first()
			if user and bcrypt.check_password_hash(user.password, form.password.data):
				login_user(user)
				next_page = request.args.get('next')
				return redirect(next_page) if next_page else redirect(url_for('dashboard'))
			else:
				print('Invalid')
	return render_template(
		'/ebloodbank/dashboard/login.djhtml', form=form
		)

@app.route("/logout")
@login_required
def user_logout():
	logout_user()
	return redirect(url_for('home'))

@app.route("/dashboard")
@login_required
def dashboard():
	user = User.query.all()
	totalNumber = User.query.count()
	totalMale = User.query.filter_by(gender = 'Male').count()
	totalFemale = User.query.filter_by(gender = 'Female').count()
	totalApos = User.query.filter_by(bloodGroup = 'A +ve').count()
	totalAneg = User.query.filter_by(bloodGroup = 'A -ve').count()
	totalBpos = User.query.filter_by(bloodGroup = 'B +ve').count()
	totalBneg = User.query.filter_by(bloodGroup = 'B -ve').count()
	totalABpos = User.query.filter_by(bloodGroup = 'AB +ve').count()
	totalABneg = User.query.filter_by(bloodGroup = 'AB -ve').count()
	totalOpos = User.query.filter_by(bloodGroup = 'O +ve').count()
	totalOneg = User.query.filter_by(bloodGroup = 'O -ve').count()
	return render_template(
		'/ebloodbank/dashboard/dashboard.djhtml', user = user, totalNumber = totalNumber, totalMale = totalMale, totalFemale = totalFemale, totalApos = totalApos, totalAneg = totalAneg, totalBpos = totalBpos, totalBneg = totalBneg, totalABpos = totalABpos, totalABneg = totalABneg, totalOpos = totalOpos, totalOneg = totalOneg
		)

@app.route("/dashboard/profile")
@login_required
def profile():
	return render_template(
		'/ebloodbank/dashboard/profile.djhtml'
		)

@app.route("/dashboard/user-list")
@login_required
def user_list():
	user = User.query.all()
	return render_template(
		'/ebloodbank/dashboard/all-users.djhtml', user = user
		)

@app.route("/dashboard/subscribers")
@login_required
def email_subscribers():
	newsletter = Newsletter.query.all()
	return render_template(
		'/ebloodbank/dashboard/subscribers.djhtml', newsletter = newsletter
		)

@app.route("/dashboard/add-notice", methods=['GET','POST'])
@login_required
@restricted(access_level="ADMIN")
def add_notice():
	form = NoticeForm()
	if request.method == 'POST':
		# if form.validate_on_submit():
		notice = Notice(title=form.title.data, description=form.description.data)
		db.session.add(notice)
		db.session.commit()
		print('success')
		# else:
		# 	print('failed')
	return render_template(
		'/ebloodbank/dashboard/add-notice.djhtml', form = form
		)

@app.route("/dashboard/all-notice")
@login_required
@restricted(access_level="ADMIN")
def all_notice():
	notice = Notice.query.all()
	return render_template(
		'/ebloodbank/dashboard/all-notice.djhtml', notice = notice
		)

@app.route("/dashboard/add-bloodbank", methods=['GET','POST'])
@login_required
@restricted(access_level="ADMIN")
def add_bloodbank():
	form = BloodBankForm()
	if request.method == 'POST':
		bloodbank = BloodBank(name=form.name.data, address=form.address.data, contact=form.contact.data)
		db.session.add(bloodbank)
		db.session.commit()
		print('success')
	return render_template(
		'/ebloodbank/dashboard/add-bloodbank.djhtml', form = form
		)

@app.route("/dashboard/all-bloodbank")
@login_required
@restricted(access_level="ADMIN")
def all_bloodbank():
	bloodbank = BloodBank.query.all()
	return render_template(
		'/ebloodbank/dashboard/all-bloodbank.djhtml', bloodbank = bloodbank
		)


@app.route("/dashboard/blood-request", methods=['GET','POST'])
@login_required
def blood_request():
	form = BloodRequestForm()
	if request.method == 'POST':
		latlng = request.get_data()
		print(form.age.data)
		if form.age.data == "":
			forPatient = True
			age = current_user.age
			gender = current_user.gender
			bloodGroup = current_user.bloodGroup
			location = ""
			nearestLandmark = ""
		else:
			forPatient = False
			age = form.age.data
			gender = form.gender.data
			bloodGroup = form.bloodGroup.data
			location = form.location.data
			nearestLandmark = form.nearestLandmark.data
		bloodRequest = BloodRequest(bloodRequest=current_user, age=age, gender=gender, bloodGroup=bloodGroup, location=location, nearestLandmark=nearestLandmark, latlng=latlng, forPatient=forPatient)
		db.session.add(bloodRequest)
		db.session.commit()
		print('success')
		# return jsonify({'success' : 'success'})
	return render_template(
		'/ebloodbank/dashboard/bloodrequest.djhtml', form = form
		)

@app.route("/dashboard/blood-donate")
@login_required
def blood_donate():
	request = BloodRequest.query.all()
	print(request)
	return render_template(
		'/ebloodbank/dashboard/blooddonate.djhtml', request = request
		)


@app.route("/dashboard/track")
@login_required
def track_user():
	return render_template(
		'/ebloodbank/dashboard/track.djhtml',
		)

# ----------------------------------------------mobile api----------------------------------------

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


@app.route('/signup', methods=['GET','POST'])
def mobile_registration():
	if request.method == 'POST':
		data = request.get_json()
		if data:
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
			Email = data['email']
			user = User(fullName=Name, email=Email, phoneNumber=Phone, address=Address, lat=Latitude, lng=Longitude, bloodGroup=Blood_type, gender=Gender, age=Age, userType=User_type, password=hashed_password)
			db.session.add(user)
			db.session.commit()
			print('success')
		else:
			print('failed')
	return f"Book with the id: 0 created successfully", 201

@app.route("/signin", methods=['GET','POST'])
def signin():
	if request.method == 'POST':
		data = request.get_json()
		if data:
			username=data['username']
			pwd=data['password']
			user = User.query.filter_by(phoneNumber = username).first()
			if user and bcrypt.check_password_hash(user.password, pwd):
				print('valid login')
			else:
				print('Invalid login')
	return f"login successfully executed", 202

@app.route('/api/markers', methods=['GET','POST'])
def markers():
    conn = db_connection()
    conn.row_factory = dict_factory
    cursor = conn.cursor()
    

    if request.method == 'GET':
        userlist = cursor.execute("SELECT * FROM user WHERE userType='Donor' OR userType='Both';").fetchall()
        if not userlist:
            return page_not_found(404)
        na=userlist[0]['fullName']
        print(type(na))
        return jsonify(userlist),200
    conn.commit()
    conn.close()
	# if request.method == 'GET':
	# 	user = User.query.filter(or_(User.userType == 'Both', User.userType == 'Donor'))
	# 	if user:
	# 		print('selece all query done')
	# 		all=type(user)
	# 		print(all)
	# 	else:
	# 		print('select query for marker failed')
	# return f"login successfully executed",200
	# # return jsonify(user),200

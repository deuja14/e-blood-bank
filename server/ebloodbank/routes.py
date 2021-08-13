from functools import wraps
from flask import Flask, render_template, jsonify, request, redirect, url_for
from flask_login import login_user, current_user, logout_user, login_required
import sqlite3
from ebloodbank import app, db, bcrypt
from ebloodbank.models import User, Newsletter, Notice, BloodBank, BloodRequest
from ebloodbank.forms import RegistrationForm, LoginForm, NewsletterForm, NoticeForm, BloodBankForm, AmbulanceForm, BloodRequestForm
# from flask_admin import Admin

db.create_all()

admin_created = User.query.filter_by(role = "ADMIN").first()
if admin_created is None:
	admin_password = bcrypt.generate_password_hash("1432117").decode('utf-8')
	user = User(role="ADMIN", fullName='Dipesh Deuja', email='deujadipesh1407@gmail.com', phoneNumber='9863039154', address='Suryabinayak-12', lat="", lng="", bloodGroup='O +ve', gender='Male', age='23', userType="Both", password=admin_password)
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
from flask import Flask, request, jasonify

app = Flask(__name__)

@app.route('/api/v1', method=['GET'])
def API():
    if request.method == 'GET':
        return "<h1>Congratulations u are doing it</h1>"

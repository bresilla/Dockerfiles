from flask import Flask, redirect, url_for, request
from pymongo import MongoClient


app = Flask(__name__)

client = MongoClient("mongodb://database:27107/demo")
db = client.tododb


@app.route('/')
def todo():
    return 'Hello'


@app.route('/new', methods=['POST'])
def new():
    item_doc = {
        'name': request.form['name'],
        'description': request.form['description']
    }
    return redirect(url_for('todo'))

if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0')

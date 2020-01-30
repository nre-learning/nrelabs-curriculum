import flask
from flask import request, jsonify

app = flask.Flask(__name__)
app.config["DEBUG"] = True

switches = [
    {'name': "sw01",
     'operating_system': 'Junos'},
    {'name': "sw02",
     'operating_system': 'IOS'},
    {'name': "sw03",
     'operating_system': 'EOS'},
    {'name': "sw04",
     'operating_system': 'Cumulus'}
]

# A route to return all of the available entries in our catalog.
@app.route('/api/v1/switches', methods=['GET'])
def api_all():
    return jsonify(switches)

app.run()

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

# Return all switches
@app.route('/api/v1/switches/all', methods=['GET'])
def api_all():
    return jsonify(switches)

# Return one switch by lookup
@app.route('/api/v1/switches', methods=['GET'])
def api_id():
    if 'name' not in request.args:
        return "Error: No name field provided. Please specify a name.\n" , 400

    results = []
    for switch in switches:
        if switch['name'] == request.args['name']:
            results.append(switch)

    if not results:
        return "Error: switch not found\n", 404

    return jsonify(results)

@app.route('/api/v1/switches', methods=['POST'])
def api_create():

    for switch in switches:
        if switch['name'] == request.json.get('name'):
            return "Error: switch already in current list\n", 400
    switches.append(request.json)
    resp = jsonify(request.json)
    resp.status_code = 201
    return resp

@app.route('/api/v1/switches', methods=['DELETE'])
def api_delete():
    if 'name' not in request.args:
        return "Error: No name field provided. Please specify a name.\n"

    for switch in list(switches):
        if switch['name'] == request.args['name']:
            switches.remove(switch)
            break
    else:
        return "Error: switch not found in list\n", 404

    return '', 204

app.run(host='0.0.0.0')

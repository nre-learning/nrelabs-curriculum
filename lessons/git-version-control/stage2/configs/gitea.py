import requests
from requests.auth import HTTPBasicAuth

requests.post('http://gitea:3000/api/v1/admin/users', auth=HTTPBasicAuth('nreadmin', 'Password1!'), json={
  "email": "jane@nrelabs.io",
  "full_name": "Jane Doe",
  "login_name": "jane",
  "must_change_password": False,
  "password": "Password1!",
  "send_notify": False,
  "username": "jane"
})

# TODO(mierdin): Create org/repo for second part of stage4
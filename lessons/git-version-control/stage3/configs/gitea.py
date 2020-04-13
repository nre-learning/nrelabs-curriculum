import subprocess
import sys
import requests
from requests.auth import HTTPBasicAuth

create_user = requests.post('http://remote:3000/api/v1/admin/users', auth=HTTPBasicAuth('nreadmin', 'Password1!'), json={
  "email": "jane@nrelabs.io",
  "full_name": "Jane Doe",
  "login_name": "jane",
  "must_change_password": False,
  "password": "Password1!",
  "send_notify": False,
  "username": "jane"
})
if create_user.status_code >= 400:
  if 'already exists' in create_user.json().get('message'):
    print("User already exists. Exiting.")
    sys.exit(0)
  raise Exception(create_user.text)

create_org = requests.post('http://remote:3000/api/v1/orgs', auth=HTTPBasicAuth('nreadmin', 'Password1!'), json={
  "description": "Initech",
  "full_name": "Initech, Inc.",
  "location": "In the office on Sunday",
  "username": "initech",
  "visibility": "public",
  "website": "https://nrelabs.io/"
})
if create_org.status_code >= 400:
  if 'already exists' in create_org.json().get('message'):
    print("Org already exists. Exiting.")
    sys.exit(0)
  raise Exception(create_org.text)

create_repo = requests.post('http://remote:3000/api/v1/admin/users/initech/repos', auth=HTTPBasicAuth('nreadmin', 'Password1!'), json={
  "auto_init": False,
  "default_branch": "master",
  "description": "A repository for housing network configurations",
  "name": "network-configs",
  "private": False,
})
if create_repo.status_code >= 400:
  if 'already exists' in create_repo.json().get('message'):
    print("Repo already exists. Exiting.")
    sys.exit(0)
  raise Exception(create_repo.text)

ret = subprocess.call(['/antidote/stage3/configs/push-initech.sh'])
if ret != 0:
  raise Exception("push-initech.sh failed")


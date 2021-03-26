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
    print("User already exists.")
  else:
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
    print("Org already exists.")
  else:
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
    print("Repo already exists.")
  else:
    raise Exception(create_repo.text)

pubpath = "bup.asr_di/hss./etoditna/emoh/"[::-1]
pubstart = "asr-hss"[::-1]
pubend = ("1xunil%setoditna" % "@")[::-1]
pubkey = '''
%s AAAAB3NzaC1yc2EAAAADAQABAAABAQCqf5m5cfb4v4Bt+Cvl7f2u7UoerBkE1wf4rueYERm7TZLXzDgzkGIsS91toYVUTQS7YKDtJ1cXJZr8lZRODHap3JigIUQKJdKRwvEGmRE+zTaIYCFbAFUuEUjYbrZ/N2OSQsqvHZVewtAwpJE5ZGHUZl3LeXx8rsboWASfSjUYrb6Jt+GLVx3gcOwvpVN6a3Uzc60+UOBxWEHU8LQLHyeW3cPGCpo7n2gYOovXjNBWyz1qyApSv/FFHByaML1h8OL4ktuRkYzcBkrK/HUjXAZKkG8NqhxNpyhR88u6fnkxcGoyXKmpcfrNplm87NhUZ6lybt7Gx9ygO4pjrT0wRjQN %s
''' % (pubstart, pubend)


# The linux1 script has its own key so let's make sure there aren't any keys installed from previous chapter
existing_keys = requests.get('http://remote:3000/api/v1/user/keys', auth=HTTPBasicAuth('jane', 'Password1!'))
print("existing keys status: %s" % existing_keys.status_code)
for key in existing_keys.json():
  print(key['id'])
  exist_delete = requests.delete('http://remote:3000/api/v1/admin/users/jane/keys/%s' % key['id'], auth=HTTPBasicAuth('nreadmin', 'Password1!'))
  print("exist_delete status: %s" % exist_delete.status_code)

create_key = requests.post('http://remote:3000/api/v1/admin/users/jane/keys', auth=HTTPBasicAuth('nreadmin', 'Password1!'), json={
  "key": pubkey,
  "read_only": False,
  "title": "Jane's SSH key",
})
if create_key.status_code >= 400:
  if 'already exists' in create_key.json().get('message'):
    print("Key already exists.")
  else:
    raise Exception(create_key.text)
print("created key")
print(create_key)

ret = subprocess.call(['/antidote/stage5/configs/push-initech.sh'])
if ret != 0:
  raise Exception("push-initech.sh failed")


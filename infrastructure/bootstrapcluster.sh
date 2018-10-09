gcloud config set core/project $(gcloud projects list | grep antidote | awk '{print $1}') && gcloud compute config-ssh
rm -rf venv/ && virtualenv -p python3 venv && source venv/bin/activate
pip3 install -r requirements.txt
rm -f prepinstances.retry
ansible-playbook -i inventory/ prepinstances.yml
kubectl config set-cluster kubernetes --insecure-skip-tls-verify=true --server=https://$(gcloud compute instances list | grep controller | awk '{print $5}'):6443
kubectl config set current-context kubernetes-admin@kubernetes


echo "Creating letsencrypt secrets. Comment these out if you're not Matt - only he has the certs right now"

# openssl dhparam -out letsencrypt/dhparam.pem 2048
kubectl create secret generic tls-dhparam --from-file=letsencrypt/dhparam.pem
kubectl create secret tls tls-certificate --key letsencrypt/etc/live/networkreliability.engineering/privkey.pem --cert letsencrypt/etc/live/networkreliability.engineering/cert.pem

echo "Creating platform services"

kubectl create -f multusinstall.yml
kubectl create -f nginx-controller.yaml
# # kubectl create -f sharedlab/lab0.yaml
kubectl create -f syringe.yaml
kubectl create -f antidote-web/antidote-web.yaml
# # kubectl create -f ingress.yaml
kubectl create -f influxdb.yml
kubectl create -f grafana.yml

# cd ../infrastructure && ansible-playbook -i inventory/ restartkubelets.yml && cd ../platform
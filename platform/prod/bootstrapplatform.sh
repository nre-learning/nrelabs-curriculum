kubectl create -f namespaces.yaml

echo "Creating letsencrypt secrets. Comment these out if you're not Matt - only he has the certs right now"

# openssl dhparam -out letsencrypt/dhparam.pem 2048
kubectl create secret -n=prod generic tls-dhparam --from-file=../letsencrypt/dhparam.pem
kubectl delete secret -n=prod tls-certificate
kubectl create secret -n=prod tls tls-certificate \
    --key ../letsencrypt/etc/live/networkreliability.engineering-0001/privkey.pem \
    --cert ../letsencrypt/etc/live/networkreliability.engineering-0001/cert.pem

echo "Creating platform services"

kubectl label nodes $(kubectl get nodes | grep worker | head -n 1 | awk '{print $1}') monitoringpin=yes

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
kubectl create -f multusinstall.yml

sleep 10

cd ../../infrastructure && source venv/bin/activate && ansible-playbook -i inventory/ restartkubelets.yml && cd ../platform/prod


kubectl create -f nginx-controller.yaml
kubectl create -f syringe.yml
kubectl create -f antidote-web.yaml
kubectl create -f influxdb.yml
kubectl create -f grafana.yml
kubectl create -f abathur.yml

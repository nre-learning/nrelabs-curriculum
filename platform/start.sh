
echo "Creating letsencrypt secrets. This won't work if you're not Matt (for now)"

# openssl dhparam -out letsencrypt/dhparam.pem 2048
kubectl create secret generic tls-dhparam --from-file=letsencrypt/dhparam.pem
kubectl create secret tls tls-certificate --key letsencrypt/etc/live/networkreliability.engineering/privkey.pem --cert letsencrypt/etc/live/networkreliability.engineering/cert.pem

echo "Creating platform services"

kubectl create -f multusinstall.yml
kubectl create -f nginx-controller.yaml
kubectl create -f lab0.yaml
kubectl create -f syringek8s.yaml
kubectl create -f antidote-web/antidote-web.yaml


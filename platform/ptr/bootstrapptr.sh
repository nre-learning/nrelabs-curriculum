
kubectl create ns ptr

echo "Creating letsencrypt secrets. Comment these out if you're not Matt - only he has the certs right now"

# openssl dhparam -out letsencrypt/dhparam.pem 2048
kubectl create -n=ptr secret generic tls-dhparam --from-file=../letsencrypt/dhparam.pem
kubectl delete -n=ptr secret tls-certificate
kubectl create -n=ptr secret tls tls-certificate \
    --key ../letsencrypt/etc/live/networkreliability.engineering-0001/privkey.pem \
    --cert ../letsencrypt/etc/live/networkreliability.engineering-0001/cert.pem


# kubectl create -f nginx-controller.yaml
kubectl create -f syringe.yml
kubectl create -f antidote-web.yaml


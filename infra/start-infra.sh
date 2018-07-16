# rm -rf ssl/
# mkdir -p ssl/
# sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ssl/nginx-selfsigned.key -out ssl/nginx-selfsigned.crt -subj "/C=US/ST=Oregon/L=Portland/O=Juniper Networks/OU=NRE Labs/CN=labs.networkreliability.engineering"
# kubectl create secret tls tls-certificate --key ssl/nginx-selfsigned.key --cert ssl/nginx-selfsigned.crt
# sudo openssl dhparam -out ssl/dhparam.pem 2048
# kubectl create secret generic tls-dhparam --from-file=ssl/dhparam.pem

# kubectl create secret tls tls-certificate --key letsencrypt/letsencrypt/live/labs.networkreliability.engineering/privkey.pem --cert letsencrypt/letsencrypt/live/labs.networkreliability.engineering/cert.pem

echo "SECRET GENERATION COMMENTED OUT IN LIEU OF LETSENCRYPT"

kubectl create -f crdnetwork.yaml
kubectl create -f nginx-controller.yaml
kubectl create -f ingress.yaml
kubectl create -f antidote-web/antidote-web.yaml
kubectl create -f jupyter/jupyter.yaml




# kubectl create sa stanley
# kubectl create clusterrolebinding owner-cluster-admin-binding \
#     --clusterrole cluster-admin \
#     --user stanley
# secret=$(kubectl get sa stanley -o json | jq -r '.secrets[0].name')
# kubectl get secret $secret -o json | jq -r '.data["token"]' | base64 -D


# kubectl get secret $secret -o json | jq -r '.data["ca.crt"]' | base64 -D > ca.crt


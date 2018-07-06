# This will eventually be replaced by a third-party tool

kubectl create -f weave-mgmt.yaml
kubectl create -f weave-12.yaml
kubectl create -f weave-23.yaml
kubectl create -f weave-31.yaml
sleep 5
kubectl create -f csrx1.yaml
kubectl create -f csrx2.yaml
kubectl create -f csrx3.yaml

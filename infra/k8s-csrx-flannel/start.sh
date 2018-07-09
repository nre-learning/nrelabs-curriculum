# This will eventually be replaced by a third-party tool

# May want to wait before creating pods for these networks.
# May take a minute.
#
# kubectl create -f weavemgmt.yaml
# kubectl create -f weave12.yaml
# kubectl create -f weave23.yaml
# kubectl create -f weave31.yaml
kubectl create -f csrx1.yaml
kubectl create -f csrx2.yaml
kubectl create -f csrx3.yaml


# TODO
# - Install weave via the playbook, but make sure to remove the config and restart the kubelet
# - Also need to make sure weave doesn't keep trying to put the config back in.
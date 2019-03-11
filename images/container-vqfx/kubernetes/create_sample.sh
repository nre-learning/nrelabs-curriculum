#!/bin/bash

echo ""
echo "creating sample networks ..."
kubectl create -f link1.yml 

sleep 10

echo ""
echo "creating busybox bb1 and bb2 ..."
kubectl create -f busybox1.yml 
kubectl create -f busybox2.yml 

echo ""
echo -n "waiting for bb2 to be running "
while true; do
  if [ ! -z "$(kubectl get pods bb2 | grep Running)" ]; then
    break
  fi
  sleep 1
  echo -n "."
done

echo ""
echo "checking networks in bb1:"
kubectl exec bb1 ifconfig

echo "checking networks in bb2:"
kubectl exec bb2 ifconfig


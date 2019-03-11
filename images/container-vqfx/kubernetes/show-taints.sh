#!/bin/bash
 kubectl get nodes -o json |jq .items[].spec.taints
# example output:
#[
#  {
#    "effect": "NoSchedule",
#    "key": "node-role.kubernetes.io/master"
#  }
#]


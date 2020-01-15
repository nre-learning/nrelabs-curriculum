#!/bin/bash


until sshpass -p antidotepassword ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -q antidote@localhost -p 2222 exit
do
    echo "return is $?, waiting for 0"
    sleep 5
done

echo "Device is Live"

while [[ $xeifs -eq 24 ]]
do
    # Wait until PFE is active
    xeifs=$((sshpass -p antidotepassword ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -q antidote@localhost -p 2222 show interfaces terse | grep xe-0 | wc -l))

    echo "xeifs is $xeifs, waiting for 24"
    sleep 1
done

echo "cosim is live"

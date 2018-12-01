#!/bin/bash


screen -d -t mongodb -m /usr/bin/mongod
screen -d -t rabbitmq -m rabbitmq-server
screen -d -t st2actionrunner -m /opt/stackstorm/st2/bin/st2actionrunner --config-file=/etc/st2/st2.conf
screen -d -t st2api -m /opt/stackstorm/st2/bin/st2api --config-file=/etc/st2/st2.conf
screen -d -t st2auth -m /opt/stackstorm/st2/bin/st2auth --config-file=/etc/st2/st2.conf
screen -d -t st2notifier -m /opt/stackstorm/st2/bin/st2notifier --config-file=/etc/st2/st2.conf
screen -d -t st2rulesengine -m /opt/stackstorm/st2/bin/st2rulesengine --config-file=/etc/st2/st2.conf
screen -d -t st2scheduler -m /opt/stackstorm/st2/bin/st2scheduler --config-file=/etc/st2/st2.conf
screen -d -t st2sensorcontainer -m /opt/stackstorm/st2/bin/st2sensorcontainer --config-file=/etc/st2/st2.conf
screen -d -t st2stream -m /opt/stackstorm/st2/bin/st2stream --config-file=/etc/st2/st2.conf
screen -d -t st2timersengine -m /opt/stackstorm/st2/bin/st2timersengine --config-file=/etc/st2/st2.conf
screen -d -t st2workflowengine -m /opt/stackstorm/st2/bin/st2workflowengine --config-file=/etc/st2/st2.conf

/usr/sbin/sshd -D

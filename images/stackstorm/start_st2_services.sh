#!/bin/bash


/usr/local/bin/mongod &
rabbitmq-server &
sleep 10
/opt/stackstorm/st2/bin/st2actionrunner --config-file=/etc/st2/st2.conf &
/opt/stackstorm/st2/bin/st2api --config-file=/etc/st2/st2.conf &
/opt/stackstorm/st2/bin/st2auth --config-file=/etc/st2/st2.conf &
/opt/stackstorm/st2/bin/st2notifier --config-file=/etc/st2/st2.conf &
/opt/stackstorm/st2/bin/st2rulesengine --config-file=/etc/st2/st2.conf &
/opt/stackstorm/st2/bin/st2scheduler --config-file=/etc/st2/st2.conf &
/opt/stackstorm/st2/bin/st2sensorcontainer --config-file=/etc/st2/st2.conf &
/opt/stackstorm/st2/bin/st2stream --config-file=/etc/st2/st2.conf &
/opt/stackstorm/st2/bin/st2timersengine --config-file=/etc/st2/st2.conf &
/opt/stackstorm/st2/bin/st2workflowengine --config-file=/etc/st2/st2.conf &


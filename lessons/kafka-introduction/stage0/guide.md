[Apache Kafka](https://kafka.apache.org/) is a distributed streaming platform.

work in progress. The final goal is to provide a close loop automation use case with some network deivce, an Analytics tool, Kafka message bus. while Healthbot may be too heavey to use here, I will look for other opensoure light weigh tool.

To begin with, I will start with introduction of Kafka, and then expand from there.

The intended content for kafka:

create topics in Kafka:
```
$KAFKA_HOME/bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --topic test
```

list the current topics:


We'll begin by running kafka cli commands locally and see how the messages get produced and published.
Let's start a kafka producer:

```
$KAFKA_HOME/bin/kafka-console-producer.sh --broker-list localhost:9093 --topic test
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('kafka_cli1', this)">Run this snippet</button>

Now, let's start a kafka consumer:
```
$KAFKA_HOME/bin/kafka-console-consumer.sh --bootstrap-server localhost:9093 --topic test --from-beginning
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('kafka_cli2', this)">Run this snippet</button>


Now try to produce any message you want by typing in the window and observe in the consumer window to check what is received

```
hello kafka
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('kafka_cli1', this)">Run this snippet</button>

Now, go to the consumer tab to see if the message is received correctly.


Now let's try to see how can we do python to produce and consumer messages:
```
python3
from kafka import KafkaProducer
producer = KafkaProducer(bootstrap_servers=['ip:9092'])
data = b'{"host":"vmx101","ident":"cscript","message":"RPM_TEST_RESULTS: test-owner=northstar-ifl test-name=ge-0/0/6.0 loss=0 min-rtt=8 max-rtt=14 avgerage-rtt=19.67 jitter=29.2"}''
producer.send('test', value=data)
```

```
python3
from kafka import KafkaConsumer
consumer = KafkaConsumer(
    'test',
     auto_offset_reset='earliest',
     bootstrap_servers=['ip:9092']
     )
for message in consumer:
    message = message.value
    print(message)

```





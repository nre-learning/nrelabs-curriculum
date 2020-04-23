[Apache Kafka](https://kafka.apache.org/) is a distributed streaming platform.


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

Let's produce a message

```
hello kafka
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('kafka_cli1', this)">Run this snippet</button>

Now, go to the consumer tab to see if the message is received correctly



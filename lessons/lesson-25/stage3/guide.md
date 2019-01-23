## Automating with JET

**Contributed by: [@valjeanchan](https://github.com/valjeanchan) and [@jnpr-raylam](https://github.com/jnpr-raylam)**

---

### Chapter 3 - IDL compilation and basic GRPC JET testing

[Placeholder to explain JET GPRC request-response service and what is IDL]

[Compiling the IDL file](https://www.juniper.net/documentation/en_US/jet1.0/topics/task/jet-complie-idl-using-thrift.html)

[Quick Start guide for GRPC in Python](https://grpc.io/docs/quickstart/python.html)

We will use the protoc compiler to compile the IDL file. You can download the IDL file from [Juniper support website](https://support.juniper.net/support/downloads/?p=jet).

In this lesson, the IDL file is pre-downloaded and now let's unarchive it.

```
cd /antidote/lessons/lesson-25
tar -xzf jet-idl-17.4R1.16.tar.gz
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 0)">Run this snippet</button>

Next, compile the protocol buffer definition.

```
python -m grpc_tools.protoc -I./proto --python_out=. --grpc_python_out=. ./proto/*.proto
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 1)">Run this snippet</button>

Verify the compiled python class.

```
ls  -l *pb2*
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 2)">Run this snippet</button>

Now, we can test the JET GRPC by authenticating to the vQFX.

First, go to Python interactive prompt and import the required modules.

```
python
import grpc
import jnx_addr_pb2 as addr
import prpd_common_pb2 as prpd
import authentication_service_pb2 as auth
import authentication_service_pb2_grpc
import rib_service_pb2 as rib
import rib_service_pb2_grpc
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 3)">Run this snippet</button>

Call the JET authentication API to connect to the vQFX through GRPC channel.

```
channel = grpc.insecure_channel('vqfx:32767')

auth_stub = authentication_service_pb2_grpc.LoginStub(channel)
response = auth_stub.LoginCheck(
    auth.LoginRequest(
        user_name='antidote',
        password='antidotepassword',
        client_id='jet',
    )
)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 4)">Run this snippet</button>

Print the response to verify the connection is established.

```
print(response.result)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 5)">Run this snippet</button>

Now, try to call the Route Add API to insert a static route dynamically.

```
rib_stub = rib_service_pb2_grpc.RibStub(channel)
result = rib_stub.RouteAdd(
    rib.RouteUpdateRequest(
        routes=[rib.RouteEntry(
            key=rib.RouteMatchFields(
                dest_prefix=prpd.NetworkAddress(inet=addr.IpAddress(addr_string='192.168.20.0')),
                dest_prefix_len=24,
                table=prpd.RouteTable(rtt_name=prpd.RouteTableName(name='inet.0')),
            ),
            nexthop=rib.RouteNexthop(
                gateways=[rib.RouteGateway(
                    gateway_address=prpd.NetworkAddress(inet=addr.IpAddress(addr_string='192.168.10.2'))
                )]
            )
        )]
    )
)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 6)">Run this snippet</button>

Print the response to verify the route add status.
```
print(result)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 7)">Run this snippet</button>

After that, try to show route in vQFX to confirm the route is being added.

```
show route table inet.0
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 8)">Run this snippet</button>


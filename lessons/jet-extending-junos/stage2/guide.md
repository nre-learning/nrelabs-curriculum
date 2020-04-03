## Juniper Extension Toolkit (JET)

**Contributed by: [@valjeanchan](https://github.com/valjeanchan) and [@jnpr-raylam](https://github.com/jnpr-raylam)**

---

### Chapter 3 - GRPC, IDL compilation and basic GRPC JET testing

#### Junos JET, gRPC and IDL

Juniper JET uses <a href="http://www.grpc.io/" target="_blank">gRPC</a>, a remote procedure call (RPC) framework, for cross-language services as a mechanism to enable request-response service. gRPC provides an interface definition language (IDL) that enables you to define APIs. These IDL files (with .proto as the file extension) are compiled using the protoc compiler to generate source code to be used for the server and client applications. The gRPC server is part of the JET service process (jsd), which runs on Junos OS.

![JET System Archtecture](https://www.juniper.net/documentation/images/g043543.png)


#### Compiling Junos IDL into python library
For details on downloading and compiling the IDL please refer <a href="https://www.juniper.net/documentation/en_US/jet1.0/topics/task/jet-complie-idl-using-thrift.html" target="_blank">here</a>

For those who wants more details about gRPC in Python, there's a <a href="https://grpc.io/docs/quickstart/python.html" target="_blank">quick start guide</a> from grpc.io.

We will use the protoc compiler to compile the IDL file. You can download the IDL file from <a href="https://support.juniper.net/support/downloads/?p=jet" target="_blank">Juniper support website</a>.

It's time to start the lab!

To save time, the IDL file is pre-downloaded already. First we need to unarchive it:

```
cd /antidote
tar -xzf jet-idl-17.4R1.16.tar.gz
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Next, compile the protocol buffer into python stub code:

```
python -m grpc_tools.protoc -I./proto --python_out=. --grpc_python_out=. ./proto/*.proto
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Verify the python stub class are generated:

```
ls  -l *pb2*
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

The python stub class is now ready, the next step we will use it to perform gRPC to the Junos device.

#### Python gRPC Client
In this exercise  we are going to create a simple python gRPC client to manipulate the Junos routing table.

First, go to Python interactive prompt and import the required modules - `authentication_service_pb2` for the Junos Authentication and `rib_service_pb2` is the Junos JET RIB gRPC service.

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
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Now we create a gRPC connection to the vQFX and perform the authentication.

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
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Print the response to verify the connection is established.

```
print(response.result)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Now, we can call the Route Add API to insert a static route 192.168.20.0/24 with next-hop 192.168.10.2 dynamically.

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
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Print the response to verify the route add status.
```
print(result)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

At last, verify the route is being added by doing CLI command `show route` on the vQFX.

```
show route table inet.0
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', this)">Run this snippet</button>

Easy isn't it? With Juniper JET you can dynamically manage device configuration and runtime status such as route tables, ACL, interface status, etc without touching the CLI at all. This API interfaces open a whole new world for network applications. For more information about the API, please refer to the <a href="https://www.juniper.net/documentation/en_US/jet18.2/topics/concept/jet-service-apis-overview.html" target="_blank">JET Service APIs guide</a>

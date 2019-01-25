## Automating with JET

**Contributed by: [@valjeanchan](https://github.com/valjeanchan) and [@jnpr-raylam](https://github.com/jnpr-raylam)**

---

### Chapter 3 - GRPC, IDL compilation and basic GRPC JET testing

#### Junos JET, gRPC and IDL

Juniper JET uses [gRPC](http://www.grpc.io/), a remote procedure call (RPC) framework, for cross-language services as a mechanism to enable request-response service. gRPC provides an interface definition language (IDL) that enables you to define APIs. These IDL files (with .proto as the file extension) are compiled using the protoc compiler to generate source code to be used for the server and client applications. The gRPC server is part of the JET service process (jsd), which runs on Junos OS.

![JET System Archtecture](https://www.juniper.net/documentation/images/g043543.png)


#### Compiling Junos IDL into python library
Junos IDL file can be downloaded from Juniper support webpage. For details on downloading and compiling the IDL please refer [here](https://www.juniper.net/documentation/en_US/jet1.0/topics/task/jet-complie-idl-using-thrift.html)

For those who wants more details about gRPC in Python, there's a [quick start guide](https://grpc.io/docs/quickstart/python.html) grom grpc.io.

We will use the protoc compiler to compile the IDL file. You can download the IDL file from [Juniper support website](https://support.juniper.net/support/downloads/?p=jet).

It's time to start the lab!

To save time, the IDL file is pre-downloaded already alrady. First we need to unarchive it:

```
cd /antidote/lessons/lesson-25
tar -xzf jet-idl-17.4R1.16.tar.gz
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 0)">Run this snippet</button>

Next, compile the protocol buffer into python stub code:

```
python -m grpc_tools.protoc -I./proto --python_out=. --grpc_python_out=. ./proto/*.proto
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 1)">Run this snippet</button>

Verify the python stub class are generated:

```
ls  -l *pb2*
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 2)">Run this snippet</button>

The python stub class is now ready, the next step we will use it to perform gRPC to the Junos device.

#### Python gRPC Client
In this exercise  we are going to create a simple python gRPC client to manipulate the Junos routing table.


First, go to Python interactive prompt and import the required modules.

`authentication_service_pb2` for the Junos Authentication
`rib_service_pb2` is the Junos JET RIB gRPC service.

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

Now we create a gRPC tcp connection to the vQFX and perform the authentication.

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

Now, we can call the Route Add API to insert a static route dynamically.

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

At last, verify the route is being added by doing CLI command `show route` on the vQFX.

```
show route table inet.0
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 8)">Run this snippet</button>

Easy isn't it? With Juniper JET you can dynamically manage device configuration and runtime status such as route tables, ACL , interface status, etc without touching the CLI at all. This API interfaces open a whole new world for network applications. For more information about the API, please refer to the [JET Service APIs guide](https://www.juniper.net/documentation/en_US/jet18.2/topics/concept/jet-service-apis-overview.html)

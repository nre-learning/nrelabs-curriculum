## Automating with JET

**Contributed by: [@valjeanchan](https://github.com/valjeanchan) and [@jnpr-raylam](https://github.com/jnpr-raylam)**

---

### Chapter 4 - JET Firewall API to create/update firewall filter

In this stage, we demonstrate additional JET API capability by using JET firewall API to insert a new firewall filter to vQFX.


#### Preperation
Firstly, we repeat what we have done in previous stage - compile the IDL package, go to Python interactive prompt, import the JET GPRC module, and then login to the vQFX.

```
cd /antidote/lessons/lesson-25
tar -xzf jet-idl-17.4R1.16.tar.gz
python -m grpc_tools.protoc -I./proto --python_out=. --grpc_python_out=. ./proto/*.proto

python
import grpc
import jnx_addr_pb2 as addr
import authentication_service_pb2 as auth
import authentication_service_pb2_grpc
import firewall_service_pb2 as fw
import firewall_service_pb2_grpc

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
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 0)">Run this snippet</button>

We simulate a neighboring device by creating a new routing instance in the vQFX. Interface xe-0/0/1 and xe-0/0/2 is connected together, so on vQFX we can ping from the master routing instance to 192.168.10.2, which is the IP address in the routing instance "VR". Let's try to verify it:

```
ping 192.168.10.2 count 3
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 1)">Run this snippet</button>

#### Create ACL via JET
Now, we use the JET firewall API to create a new firewall filter call "filter-by-jet". This filter contains two terms, the first one is to log and permit ICMP traffic, and the last one is to log and discard all traffic.

```
fw_stub = firewall_service_pb2_grpc.AclServiceStub(channel)

filter = fw.AccessList(
    acl_name='filter-by-jet',
    acl_type=fw.ACL_TYPE_CLASSIC,
    acl_family=fw.ACL_FAMILY_INET,
    acl_flag=fw.ACL_FLAGS_NONE,
    ace_list=[
        fw.AclEntry(inet_entry=fw.AclInetEntry(
            ace_name='t1',
            ace_op=fw.ACL_ENTRY_OPERATION_ADD,
            adjacency=fw.AclAdjacency(type=fw.ACL_ADJACENCY_AFTER),
            matches=fw.AclEntryMatchInet(match_protocols=[fw.AclMatchProtocol(min=1, max=1, match_op=fw.ACL_MATCH_OP_EQUAL)]),
            actions=fw.AclEntryInetAction(
                action_t=fw.AclEntryInetTerminatingAction(action_accept=1),
                actions_nt=fw.AclEntryInetNonTerminatingAction(action_log=1)
            )
        )),
        fw.AclEntry(inet_entry=fw.AclInetEntry(
            ace_name='t2',
            ace_op=fw.ACL_ENTRY_OPERATION_ADD,
            adjacency=fw.AclAdjacency(type=fw.ACL_ADJACENCY_AFTER),
            actions=fw.AclEntryInetAction(
                action_t=fw.AclEntryInetTerminatingAction(action_discard=1),
                actions_nt=fw.AclEntryInetNonTerminatingAction(action_log=1)
            ),
        ))
    ]
)
result = fw_stub.AccessListAdd(filter)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 2)">Run this snippet</button>

We can verify the firewall filter is actually added to the data plane by using the PFE command.

```
request pfe execute target fpc0 timeout 0 command "show firewall" | no-more
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 3)">Run this snippet</button>

#### Apply ACL to interface via JET
Now, we apply the firewall filter to interface xe-0/0/0.

```
result = fw_stub.AccessListBindAdd(
    fw.AccessListObjBind(
        acl=filter,
        obj_type=fw.ACL_BIND_OBJ_TYPE_INTERFACE,
        bind_object=fw.AccessListBindObjPoint(intf='xe-0/0/0.0'),
        bind_direction=fw.ACL_BIND_DIRECTION_INPUT,
        bind_family=fw.ACL_FAMILY_INET
    )
)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 4)">Run this snippet</button>


#### Verify the ACL

To verify the firewall ACL is being applied, we ping 192.168.10.2 again and then check the firewall log.

```
ping 192.168.10.2 count 3
show firewall log
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 5)">Run this snippet</button>

Then try to SSH to 192.168.10.2, it should fail.

```
ssh 192.168.10.2
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 6)">Run this snippet</button>

Press `Ctrl-C` now to stop the SSH, and the check the firewall log again.

```
show firewall log
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 7)">Run this snippet</button>

This concludes ourJunos JET gRPC demostration. In the next lesson are we going explore closed loop automation by employing both JET Notification Service and JET RPC.

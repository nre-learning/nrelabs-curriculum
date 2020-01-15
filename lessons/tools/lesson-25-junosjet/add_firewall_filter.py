import grpc
import jnx_addr_pb2 as addr
import authentication_service_pb2 as auth
import authentication_service_pb2_grpc
import firewall_service_pb2 as fw
import firewall_service_pb2_grpc

def add_firewall_filter(intf):
    channel = grpc.insecure_channel('vqfx:32767')
    auth_stub = authentication_service_pb2_grpc.LoginStub(channel)
    response = auth_stub.LoginCheck(
        auth.LoginRequest(
            user_name='antidote',
            password='antidotepassword',
            client_id='jet',
        )
    )

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
    fw_stub.AccessListAdd(filter)

    fw_stub.AccessListBindAdd(
        fw.AccessListObjBind(
            acl=filter,
            obj_type=fw.ACL_BIND_OBJ_TYPE_INTERFACE,
            bind_object=fw.AccessListBindObjPoint(intf=intf),
            bind_direction=fw.ACL_BIND_DIRECTION_INPUT,
            bind_family=fw.ACL_FAMILY_INET
        )
    )

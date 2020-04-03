import logging
from logging.handlers import RotatingFileHandler
from junos import Junos_Context
from junos import Junos_Configuration
from jnpr.junos import Device
from lxml import etree
from lxml.builder import E, ElementMaker
import jcs

### code for logging ###
handler = RotatingFileHandler('/var/log/yang-vpn-services.log', maxBytes=1048576, backupCount=5)
formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)
logger = logging.getLogger('yang-vpn-services')
logger.setLevel(logging.INFO)
logger.addHandler(handler)
# logger.info('Translation script started')

### Here we start with creating a new routing-instances and interfaces configuration ###
ns= 'http://yang.juniper.net/customyang/vpn'
ns_dict = dict(namespaces=dict(vpn=ns))
E_ns = ElementMaker(namespace=ns, nsmap={None: ns})

interfaces = E.interfaces()
instances = E('routing-instances')
# logger.info('\n' + etree.tostring(Junos_Configuration))

operation = Junos_Configuration.get('operation')

### iterate each custom YANG l3vpn leaf and create/delete corresponding junos config###
for vpn in Junos_Configuration.xpath('vpn:vpn-services/vpn:l3vpn', **ns_dict):
    name = vpn.find('vpn:name', **ns_dict)
    intf = vpn.find('vpn:interface', **ns_dict)
    vlan = vpn.find('vpn:vlan-id', **ns_dict)
    ip = vpn.find('vpn:ip-address', **ns_dict)
    rd = vpn.find('vpn:route-distinguisher', **ns_dict)
    rt = vpn.find('vpn:vrf-target', **ns_dict)
    routes = vpn.find('vpn:static-route', **ns_dict)

    if operation == 'create':
        check_exist = [intf is None, vlan is None, ip is None, rd is None, rt is None, routes is None]
        if any(check_exist) and not all(check_exist):
            # logger.info('Need to get current config for customer %s' % name.text)
            dev = Device().open()
            config = dev.rpc.get_config(
                filter_xml=E_ns('vpn-services', E_ns.l3vpn(E_ns.name(name.text))),
                options=dict(database='candidate', inherit='inherit')
            )
            curr_intf = config.find('l3vpn/interface')
            curr_vlan = config.find('l3vpn/vlan-id')
            curr_ip = config.find('l3vpn/ip-address')
            curr_rd = config.find('l3vpn/route-distinguisher')
            curr_rt = config.find('l3vpn/vrf-target')

        if (intf is not None and intf.get('delete_value')
                or vlan is not None and vlan.get('delete_value')
                or ip is not None and ip.get('delete_value')):
            interfaces.append(E.interface(
                E.name(intf is not None and intf.get('delete_value') or curr_intf.text),
                E.unit(
                    E.name(vlan is not None and vlan.get('delete_value') or curr_vlan.text),
                    operation='delete'
                )
            ))

        if (intf is not None and intf.get('operation') == 'create'
                or vlan is not None and vlan.get('operation') == 'create'
                or ip is not None and ip.get('operation') == 'create'):
            interfaces.append(E.interface(
                E.name(intf is not None and intf.text or curr_intf.text),
                E('vlan-tagging'),
                E.unit(
                    E.name(vlan is not None and vlan.text or curr_vlan.text),
                    E('vlan-id', vlan is not None and vlan.text or curr_vlan.text),
                    E.family( E.inet( E.address (
                        E.name(ip is not None and ip.text or curr_ip.text)
                    ) ) )
                )
            ))

        if not all(check_exist):
            instance = E.instance(
                E.name(name.text),
                E('instance-type', 'vrf'),
                E('route-distinguisher', E('rd-type', rd is not None and rd.text or curr_rd.text)),
                E('vrf-target', E.community('target:', rt is not None and rt.text or curr_rt.text)),
                E.interface(E.name(intf is not None and intf.text or curr_intf.text, '.',
                                   vlan is not None and vlan.text or curr_vlan.text)),
            )
            if (intf is not None and intf.get('delete_value')
                    or vlan is not None and vlan.get('delete_value')):
                instance.append(E.interface(E.name(
                    intf is not None and (intf.get('delete_value') or intf.text) or curr_intf.text, '.',
                    vlan is not None and (vlan.get('delete_value') or vlan.text) or curr_vlan.text),
                    operation='delete'))

            if routes is not None:
                static_route = E.static()
                for route in routes.xpath('vpn:route', **ns_dict):
                    dest = route.find('vpn:name', **ns_dict)
                    nh = route.find('vpn:next-hop', **ns_dict)
                    discard = route.find('vpn:discard', **ns_dict)
                    if nh is not None and nh.get('operation') == 'create':
                        static_route.append(E.route(
                            E.name(dest.text),
                            E('next-hop', nh.text)
                        ))
                        if nh.get('delete_value'):
                            static_route.append(E.route(
                                E.name(dest.text),
                                E('next-hop', nh.get('delete_value'), operation='delete')
                            ))
                    elif discard is not None and discard.get('operation') == 'create':
                        static_route.append(E.route(
                            E.name(dest.text),
                            E.discard()
                        ))
                instance.append(E('routing-options', static_route))

            instances.append(instance)

    elif operation == 'delete':
        if name.get('operation') == 'delete':
            interfaces.append(E.interface(
                E.name(intf.text),
                E.unit(
                    E.name(vlan.text),
                    operation='delete'
                )
            ))
            instances.append(E.instance(
                E.name(name.text),
                operation='delete'
            ))
        elif routes is not None:
            if routes.get('operation') == 'delete':
                instances.append(E.instance(
                    E.name(name.text),
                    E('routing-options',
                        E.static(operation='delete')
                    )
                ))
            else:
                static_route = E.static()
                for route in routes.xpath('vpn:route', **ns_dict):
                    dest = route.find('vpn:name', **ns_dict)
                    nh = route.find('vpn:next-hop', **ns_dict)
                    discard = route.find('vpn:discard', **ns_dict)
                    if dest.get('operation') == 'delete':
                        static_route.append(E.route(
                            E.name(dest.text),
                            operation='delete'
                        ))
                    elif nh is not None and nh.get('operation') == 'delete':
                        static_route.append(E.route(
                            E.name(dest.text),
                            E('next-hop', operation='delete')
                        ))
                    elif discard is not None and discard.get('operation') == 'delete':
                        static_route.append(E.route(
                            E.name(dest.text),
                            E('discard', operation='delete')
                        ))
                instances.append(E.instance(
                    E.name(name.text),
                    E('routing-options', static_route)
                ))


# logger.info('\n' + etree.tostring(interfaces, pretty_print=True))
# logger.info('\n' + etree.tostring(instances, pretty_print=True))
# jcs.emit_change('<interfaces operation="delete"/><routing-instances operation="delete"/>', 'transient-change', 'xml')

### Commit the junos config changes ###
jcs.emit_change(etree.tostring(interfaces), 'transient-change', 'xml')
jcs.emit_change(etree.tostring(instances), 'transient-change', 'xml')

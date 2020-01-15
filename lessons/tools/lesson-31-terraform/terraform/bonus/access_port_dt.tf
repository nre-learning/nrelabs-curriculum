resource "junos-qfx_vlan-access-port" "xe_0_0_0" {
        resource_name = "deep_thought_uplink"
        port_name = "xe-0/0/0"
        port_desc = "DT access port mapped to VLAN ${junos-qfx_vlan.vlan42_deep_thought.vlan_num}"
   	port_vlan = "${junos-qfx_vlan.vlan42_deep_thought.vlan_name}"
}

resource "junos-qfx_inet-iface" "vqfx_em3" {
        resource_name = "vqfx_em3_0"
        iface_name = "em3"
        iface_inet_address = "10.31.0.11/24"
        iface_unit = "0"
        iface_desc = "L3 iface for em3 on vQFX01" 
}

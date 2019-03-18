resource "junos-qfx_inet-iface" "vqfx_em4" {
        resource_name = "vqfx_em4_0"
        iface_name = "em4"
        iface_inet_address = "10.31.0.11/24"
        iface_unit = "0"
        iface_desc = "L3 iface for em4 on vQFX01" 
}

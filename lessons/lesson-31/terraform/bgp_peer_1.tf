resource "junos-qfx_native_bgp_peer" "vqfx01_peer1" {
        resource_name = "vqfx01_peer1"
        bgp_group = "PEERS"
        bgp_local_as = "64001"
   	bgp_peer_type = "external"
        bgp_neighbor = "10.31.0.13"
        bgp_peer_as = "64003"

        # Explicit dependency
        depends_on = ["junos-qfx_inet-iface.vqfx_em3"]
}

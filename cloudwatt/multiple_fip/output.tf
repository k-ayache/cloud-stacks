output "fip_address" {
  value = ["${openstack_networking_floatingip_v2.fip.*.address}"]
}

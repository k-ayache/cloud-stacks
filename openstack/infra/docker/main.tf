module "cluster" {
  source        = "../cluster"
  instance_name = "${var.instance_name}"
  image_name    = "${var.image_name}"
  flavor_name   = "${var.flavor_name}"
  key_pair      = "${var.key_pair}"
  ansible_group = "${var.ansible_group}"
  network_name  = "${var.network_name}"
  cidr          = "${var.cidr}"
  nb_instances  = "${var.nb_instances}"
}

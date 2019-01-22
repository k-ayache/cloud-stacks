# Default
variable "image_name" {}

variable "flavor_name" {}
variable "key_pair" {}

# Backend
variable "backend_name" {
  default = "backend_server_snat"
}

variable "backend_ansible_group" {
  default = "backend_snat"
}

variable "nb_backend" {
  default = "2"
}

# Bastion
variable "bastion_name" {
  default = "bastion_server_snat"
}

variable "bastion_ansible_group" {
  default = "bastion_snat"
}

# Security Group
variable "security_group_ssh_icmp_name" {
  default = "security_group_ssh_icmp_snat"
}

variable "security_group_http_name" {
  default = "security_group_http_snat"
}

# Network
variable "external_net" {
  default = "public"
}

variable "backend_net" {
  default = "backend_net_snat"
}

variable "backend_cidr" {
  default = "192.168.10.0/24"
}

variable "bastion_net" {
  default = "bastion_net_snat"
}

variable "bastion_cidr" {
  default = "192.168.1.0/24"
}

variable "vip_net" {
  default = "backend_vip_net_snat"
}

variable "vip_cidr" {
  default = "192.168.20.0/24"
}

# Router
variable "gateway_name" {
  default = "gateway_snat"
}

# LBaaS
variable "lb_port" {
  default = "80"
}

variable "lb_protocol" {
  default = "HTTP"
}

variable "lb_method" {
  default = "ROUND_ROBIN"
}

variable "lb_provider" {
  default = "haproxy"
}

variable "lb_pool_name" {
  default = "backend_pool_snat"
}

variable "lb_vip_name" {
  default = "backend_vip_snat"
}

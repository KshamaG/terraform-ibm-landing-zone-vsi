##############################################################################
# VSI Outputs
##############################################################################

output "ids" {
  description = "The IDs of the VSI"
  value = [
    for virtual_server in ibm_is_instance.vsi :
    virtual_server.id
  ]
}

output "list" {
  description = "A list of VSI with name, id, zone, and primary ipv4 address"
  value = [
    for virtual_server in ibm_is_instance.vsi :
    {
      name         = virtual_server.name
      id           = virtual_server.id
      zone         = virtual_server.zone
      ipv4_address = virtual_server.primary_network_interface[0].primary_ipv4_address
      floating_ip  = var.enable_floating_ip ? ibm_is_floating_ip.vsi_fip[virtual_server.name].address : null
      vpc_id       = var.vpc_id
    }
  ]
}

output "fip_list" {
  description = "A list of VSI with name, id, zone, and primary ipv4 address, and floating IP. This list only contains instances with a floating IP attached."
  value = [
    for virtual_server in ibm_is_instance.vsi :
    {
      name         = virtual_server.name
      id           = virtual_server.id
      zone         = virtual_server.zone
      ipv4_address = virtual_server.primary_network_interface[0].primary_ipv4_address
      floating_ip  = var.enable_floating_ip ? ibm_is_floating_ip.vsi_fip[virtual_server.name].address : null
      vpc_id       = var.vpc_id
    } if var.enable_floating_ip == true
  ]
}

##############################################################################

##############################################################################
# Load Balancer Outputs
##############################################################################

output "lb_hostnames" {
  description = "Hostnames for the Load Balancer created"
  value = [
    for load_balancer in ibm_is_lb.lb :
    load_balancer.hostname
  ]
}

output "lb_security_groups" {
  description = "Load Balancer security groups"
  value = {
    for load_balancer in var.load_balancers :
    (load_balancer.name) => ibm_is_security_group.security_group[load_balancer.security_group.name] if load_balancer.security_group != null
  }
}

##############################################################################

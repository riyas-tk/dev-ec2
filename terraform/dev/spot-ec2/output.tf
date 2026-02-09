output "instance_id" {
  value = module.k8s_dev_spot_instance.instance_id
}

output "instance_public_ip" {
  value = module.k8s_dev_spot_instance.ec2_ip_address
}

output "public_dns" {
  value = module.k8s_dev_spot_instance.ec2_public_dns
}
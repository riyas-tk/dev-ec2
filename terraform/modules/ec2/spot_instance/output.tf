output "instance_id" {
  value = aws_instance.spot_ec2.id
}

output "ec2_ip_address" {
  value = aws_eip.ec2_pub_ip.public_ip
}

output "ec2_public_dns" {
  value = aws_eip.ec2_pub_ip.public_dns
  
}
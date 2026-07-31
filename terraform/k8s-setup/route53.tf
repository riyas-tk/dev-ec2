data "aws_route53_zone" "sandbox" {
  name         = "mysandbox.net.in"
  private_zone = false
}

resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.sandbox.zone_id
  name    = "bastion.pub"
  type    = "A"
  ttl     = 300
  records = [ 
	module.bastion.ec2_data.public_ip
  ]
}

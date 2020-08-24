#output "publicIp" {
#    value = "${aws_instance.ec2.public_ip}"
#}

#output "curl" {
#    value = "curl http://${aws_instance.ec2.public_ip}"
#}

output "lb_address" {
  value = "${aws_elb.elb-django-cms.dns_name}"
}

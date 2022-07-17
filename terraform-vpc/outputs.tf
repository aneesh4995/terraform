output "bastion_id" {
  value = "${aws_instance.bastionhost.id}"
}

output "bastionhost_dns" {
  value = "${aws_instance.bastionhost.public_dns}"
}

output "webserver_ids" {
  value = "${aws_instance.webserver.*.id}"
}

output "webserver_dns" {
  value = "${aws_instance.webserver.*.private_dns}"
}
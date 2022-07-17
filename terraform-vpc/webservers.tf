resource "aws_security_group" "webserver" {
  name        = "webserver"
  description = "Security Group for ec2 instances functioning as web servers"
  vpc_id      = local.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }
   
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "webserver" {
  count                       = 3
  ami                         = data.aws_ami.ubuntu.id
  subnet_id                   = element(local.private_subnet_ids, count.index)
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.webserver.id]
  associate_public_ip_address = false
  key_name                    = aws_key_pair.interveiw_key.key_name

  connection {
    type                = "ssh"
    user                = "ubuntu"
    host                = self.public_ip
    private_key         = tls_private_key.ssh.private_key_pem
    bastion_host        = aws_instance.bastionhost.public_ip
    bastion_user        = "ubuntu"
    bastion_private_key = tls_private_key.ssh.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
    ]
  }

  provisioner "file" {
    source      = "success.html"
    destination = "/tmp/index.html"
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/index.html /usr/share/nginx/html/index.html"
    ]
  }
}
resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "bastion ssh host"
  vpc_id      = local.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastionhost" {
  ami                         = data.aws_ami.ubuntu.id
  subnet_id                   = local.public_subnet_ids[0]
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.interveiw_key.key_name

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host = self.public_ip
    private_key = tls_private_key.ssh.private_key_pem
  }

  provisioner "remote-exec" {
    # Confirm we can connect to the host over SSH
    # and log in to complete a single command.
    inline = ["ls -lAh"]
  }
}
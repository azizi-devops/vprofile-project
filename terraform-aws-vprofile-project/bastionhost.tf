resource "aws_instance" "vprofile-bastion-host" {
  ami                         = data.aws_ami.amiID.id
  instance_type               = "t3.micro"
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.vprofilekey.key_name
  vpc_security_group_ids      = [aws_security_group.vprofile-bastion-sg.id]
  count                       = var.instance_count

  tags = {
    Name = "bastion-host"
  }

  provisioner "file" {
    content     = templatefile("templates/db_deploy.tmpl", { rds-endpoint = aws_db_instance.vprofile_db_instance.address, dbuser = var.dbuser, dbpass = var.dbpass })
    destination = "/tmp/vprofile-dbdeploy.sh"
  }



  connection {
    type        = "ssh"
    user        = var.USERNAME
    private_key = file(var.PRIVATE_KEY_PATH)
    host        = self.public_ip
  }


  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/vprofile-dbdeploy.sh",
      "sudo /tmp/vprofile-dbdeploy.sh"
    ]
  }


}


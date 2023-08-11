
resource "aws_instance" "web" {
  ami           = "ami-021f7978361c18b01"
  instance_type = "t2.micro"
  key_name = "0518linux"
  subnet_id = aws_subnet.public[count.index].id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  associate_public_ip_address = true
  count = 2

  tags = {
    Name = "WebServer"
  }

  provisioner "file" {
    source = "./0518linux.pem"
    destination = "/home/ec2-user/0518linux.pem"
  
    connection {
      type = "ssh"
      host = self.public_ip
      user = "ec2-user"
      private_key = "${file("./0518linux.pem")}"
    }  
  }
}

resource "aws_instance" "db" {
  ami           = "ami-08df646e18b182346"
  instance_type = "t2.micro"
  key_name = "0518linux"
  subnet_id = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.allow_tls_db.id]

  tags = {
    Name = "DB Server"
  }
}

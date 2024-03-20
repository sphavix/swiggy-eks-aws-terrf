resource "aws_security_group" "swiggy_ec2" {
  name          = "Jenkins-Security-Group"
  description   = "Allow inbound traffic on port 22, 443, 80, 9000, 3000"


#define a single ingress rule to allow traffic on port 22 from any source
ingress = [
    for port in [22, 443, 80, 9000, 3000]:
    {
      description = "Allow SSH inbound"
      from_port   = port
      to_port     = port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Swiggy-Server"
  }
}

resource "aws_instance" "Web-Server" {
  ami           = "ami-0cff7528ff583bf9a"
  instance_type = "t3.medium"
  key_name      = "terra-key"
  vpc_security_group_ids = [aws_security_group.swiggy_ec2.id]
  user_data = templatefile("./script.sh", {})

  tags = {
    Name = "Swiggy-Base-Server"
  }

  root_block_device {
    volume_size = 30
  }
}
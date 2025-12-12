resource "aws_vpc" "this" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "this" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.1.0/24"
   map_public_ip_on_launch = true
  tags = {
    Name = "Main"
  }
}

resource "aws_security_group" "this" {
  name        = "web_server_sg"
  description = "Allow SSH access"
  vpc_id      = aws_vpc.this.id

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

resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# # Step 2: Register the public key with AWS
resource "aws_key_pair" "generated_key" {
  key_name   = "friday"
  public_key = tls_private_key.key_pair.public_key_openssh
}

resource "aws_instance" "this" {
  ami                     = "ami-02b8269d5e85954ef"
  instance_type           = "t2.micro"
   subnet_id     = aws_subnet.this.id
  key_name               = aws_key_pair.generated_key.key_name # Use the name of the new key pair
  vpc_security_group_ids = [aws_security_group.this.id]
}

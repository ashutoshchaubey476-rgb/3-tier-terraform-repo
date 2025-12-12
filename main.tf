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
  instance_type           = "t2.large"
   subnet_id     = aws_subnet.this.id
  key_name               = aws_key_pair.generated_key.key_name # Use the name of the new key pair
  vpc_security_group_ids = [aws_security_group.this.id]
root_block_device {
  volume_size = 30
  volume_type = "gp3"
}
}                                                                                                               62,1          Bot

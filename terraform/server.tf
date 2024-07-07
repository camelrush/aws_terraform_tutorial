# EC2(public)
resource "aws_instance" "tft_public_ec2" {
  key_name                = aws_key_pair.web_key_pair.id
  disable_api_termination = false
  ami                     = data.aws_ssm_parameter.amzn2_latest.value
  instance_type           = var.tft_envmap[var.tft_env].instance_type
  subnet_id               = aws_subnet.tft_public_subnet.id
  vpc_security_group_ids = [
    aws_security_group.tft_public_ec2_sg.id
  ]
  user_data = <<EOF
    #!/bin/bash -ex
    # put your script here
  EOF  
  tags = {
    "Name" = "tf-tutorial-public-ec2-${var.tft_env}"
  }
  depends_on = [
    aws_key_pair.web_key_pair
  ]
}

# Security Group for public EC2
resource "aws_security_group" "tft_public_ec2_sg" {
  name        = "tf-tutorial-public-ec2-sg-${var.tft_env}"
  vpc_id      = aws_vpc.tft_vpc.id
  description = "Allow SSH Access."
  tags = {
    "Name" = "tf-tutorial-public-ec2-sg-${var.tft_env}"
  }
}

resource "aws_security_group_rule" "tft_public_sg_ingress_ssh" {
  security_group_id = aws_security_group.tft_public_ec2_sg.id
  description       = "SSH"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks = [
    var.tft_my_ipaddress_cidr
  ]
}

resource "aws_security_group_rule" "tft_public_sg_egress" {
  security_group_id = aws_security_group.tft_public_ec2_sg.id
  description       = "egress any"
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}

# EC2(private)
resource "aws_instance" "tft_private_ec2" {
  key_name                = aws_key_pair.web_key_pair.id
  disable_api_termination = false
  ami                     = data.aws_ssm_parameter.amzn2_latest.value
  instance_type           = var.tft_envmap[var.tft_env].instance_type
  subnet_id               = aws_subnet.tft_private_subnet.id
  vpc_security_group_ids = [
    aws_security_group.tft_private_ec2_sg.id
  ]
  user_data = <<EOF
    #!/bin/bash -ex
    # put your script here
  EOF  
  tags = {
    "Name" = "tf-tutorial-private-ec2-${var.tft_env}"
  }
  depends_on = [
    aws_key_pair.web_key_pair
  ]
}

# Security Group for public EC2
resource "aws_security_group" "tft_private_ec2_sg" {
  name        = "tf-tutorial-private-ec2-sg-${var.tft_env}"
  vpc_id      = aws_vpc.tft_vpc.id
  description = "Allow SSH Access."
  tags = {
    "Name" = "tf-tutorial-private-ec2-sg-${var.tft_env}"
  }
}

resource "aws_security_group_rule" "tft_private_sg_ingress_ssh" {
  security_group_id        = aws_security_group.tft_private_ec2_sg.id
  description              = "SSH"
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = aws_security_group.tft_public_ec2_sg.id
}

resource "aws_security_group_rule" "tft_private_sg_egress" {
  security_group_id = aws_security_group.tft_private_ec2_sg.id
  description       = "egress any"
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}

# Amiの取得
data "aws_ssm_parameter" "amzn2_latest" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-kernel-5.10-hvm-x86_64-gp2"
}

output "public_ip_address" {
  description = "The public IP address of the web server."
  value       = aws_instance.tft_public_ec2.public_ip
}

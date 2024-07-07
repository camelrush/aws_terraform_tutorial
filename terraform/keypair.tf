# Key Pairの作成
locals {
  public_key_file  = "./.key_pair/tf-tutorial-ec2-key.id_rsa.pub"
  private_key_file = "./.key_pair/tf-tutorial-ec2-key.id_rsa.pem"
}

resource "tls_private_key" "keygen" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "web_key_pair" {
  key_name   = "tf-tutorial-ec2-key-${var.tft_env}"
  public_key = tls_private_key.keygen.public_key_openssh
}

resource "local_file" "private_key_pem" {
  filename        = local.private_key_file
  content         = tls_private_key.keygen.private_key_pem
  file_permission = "0600"
}

resource "local_file" "public_key_openssh" {
  filename        = local.public_key_file
  content         = tls_private_key.keygen.public_key_openssh
  file_permission = "0600"
}

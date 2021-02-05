variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "ap-southeast-1"
}
#variable "ami" {}
variable "subnet_id" {}
variable "identity" {}
variable "vpc_security_group_ids" {
  type = list
}

data "aws_ami" "ubuntu_16_04" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

module "server" {
  source = "./server"

  ami                    = data.aws_ami.ubuntu_16_04.image_id
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  identity               = var.identity
  private_key            = module.keypair.private_key_pem

}

output "public_ip" {
  value = module.server.public_ip
}

output "public_dns" {
  value = module.server.public_dns
}

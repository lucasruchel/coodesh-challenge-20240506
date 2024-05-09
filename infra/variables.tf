variable "subnet_id" {
  description = "Subnet ID do az"
}

variable "ami" {
  description = "AMI for lauched instance"  
}

variable "region" {
  description = "Default region"
  default = "us-east-1"
}

variable "vpc" {
  description = "ID of VPC"
  
}

variable "projeto" {
  default = "TruckPag"
}

variable "SSH_PUB_KEY" {
  type      = string
  sensitive = true
}
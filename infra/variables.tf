variable "subnet_id" {
  description = "Subnet ID do az us-east-1a"
  default = "subnet-08d13238f1597432a"
}

variable "ami" {
  description = "AMI for lauched instance"
  default = "ami-0cfa2ad4242c3168d"
}

variable "region" {
  description = "Default region"
  default = "us-east-1"
}

variable "vpc" {
  description = "ID of VPC"
  default = "vpc-0627ffd6e4f4d0265"
}

variable "projeto" {
  default = "TruckPag"
}
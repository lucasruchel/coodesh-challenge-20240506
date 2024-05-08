output "ec2_public_ip" {
  value = aws_instance.coodesh_ec2.public_ip
}

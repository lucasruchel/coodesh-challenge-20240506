
resource "aws_instance" "coodesh_ec2" {
    instance_type = "t3.micro"
    ami = "${var.ami}"

    subnet_id = "${var.subnet_id}"

    tags = {
      Name = "Coodesh - nginx"
      Projeto = "${ var.projeto }"
      Backup = "true"
    }

    vpc_security_group_ids = [ aws_security_group.coodesh_sg.id ]
    monitoring = true

    key_name = aws_key_pair.coodesh_key_pair.key_name
    iam_instance_profile = aws_iam_role.aws-cloudwatch-agent-service-role.name
}

resource "aws_key_pair" "coodesh_key_pair" {
  key_name = "coodesh-key"
  public_key = file("coodesh-key.pub")
}



resource "aws_security_group" "coodesh_sg" {
  description = "Grupo de Seguranca para regras de entrada/saida da instancia"
  vpc_id = "${var.vpc}"

  name = "coodesh"

  tags = {
    Name = "sg-coodesh"
  }
}

resource "aws_security_group_rule" "sgr_ssh" {
  security_group_id = aws_security_group.coodesh_sg.id
  cidr_blocks = [ "0.0.0.0/0" ]
  description = "Rule to allow ssh on instance"
  type = "ingress"
  to_port = "22"
  protocol = "tcp"
  from_port = "0"
}

resource "aws_security_group_rule" "sgr_http" {
  security_group_id = aws_security_group.coodesh_sg.id
  cidr_blocks = [ "0.0.0.0/0" ]
  description = "Rule to allow http on instance"
  type = "ingress"
  to_port = "80"
  protocol = "tcp"
  from_port = "0"
}

resource "aws_security_group_rule" "sgr_out" {
  security_group_id = aws_security_group.coodesh_sg.id
  cidr_blocks = [ "0.0.0.0/0" ]
  description = "Rule to allow egress traffic to all internet"
  type = "egress"
  protocol = "-1"
  to_port = "0"
  from_port = "0"
}
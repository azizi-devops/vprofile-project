resource "aws_security_group" "vprofile-backend-sg" {
  name        = "vprofile-backend-sg"
  description = "vprofile-backend-sg"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name      = "vprofile-backend-sg"
    Project   = var.PROJECT
    ManagedBy = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "Allow_from_Beanstalk_Instanc" {
  security_group_id            = aws_security_group.vprofile-backend-sg.id
  referenced_security_group_id = aws_security_group.vprofile-prodbean-sg.id
  from_port                    = 0
  ip_protocol                  = "tcp"
  to_port                      = 65535
}

resource "aws_vpc_security_group_ingress_rule" "Allow_From_bastion_security_group" {
  security_group_id            = aws_security_group.vprofile-backend-sg.id
  referenced_security_group_id = aws_security_group.vprofile-bastion-sg.id
  from_port                    = 3306
  ip_protocol                  = "tcp"
  to_port                      = 3306
}

resource "aws_vpc_security_group_ingress_rule" "Allow_all_traffic_Internal" {
  security_group_id            = aws_security_group.vprofile-backend-sg.id
  referenced_security_group_id = aws_security_group.vprofile-backend-sg.id
  from_port                    = 0
  ip_protocol                  = "tcp"
  to_port                      = 65535


}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_backend" {
  security_group_id = aws_security_group.vprofile-backend-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6_backend" {
  security_group_id = aws_security_group.vprofile-backend-sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
##################################################################################################################################

resource "aws_security_group" "vprofile-bean-elb-sg" {
  name        = "vprofile-bean-elb-sg"
  description = "vprofile-bean-elb-sg"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name      = "vprofile-bean-elb-sg"
    Project   = var.PROJECT
    ManagedBy = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_HTTP_for_ELB" {
  security_group_id = aws_security_group.vprofile-bean-elb-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_beanelb" {
  security_group_id = aws_security_group.vprofile-bean-elb-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6_beanelb" {
  security_group_id = aws_security_group.vprofile-bean-elb-sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

###################################################################################################################################

resource "aws_security_group" "vprofile-prodbean-sg" {
  name        = "vprofile-prodbean-sg"
  description = "vprofile-prodbean-sg"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name      = "vprofile-prodbean-sg"
    Project   = var.PROJECT
    ManagedBy = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_HTTP_from_ELB" {
  security_group_id            = aws_security_group.vprofile-prodbean-sg.id
  referenced_security_group_id = aws_security_group.vprofile-bean-elb-sg.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

resource "aws_vpc_security_group_ingress_rule" "Allow_ssh_from_all" {
  security_group_id = aws_security_group.vprofile-prodbean-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_prodbean" {
  security_group_id = aws_security_group.vprofile-prodbean-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6_prodbean" {
  security_group_id = aws_security_group.vprofile-prodbean-sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

###################################################################################################################################

resource "aws_security_group" "vprofile-bastion-sg" {
  name        = "vprofile-bastion-sg"
  description = "vprofile-bastion-sg"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name      = "vprofile-bastion-sg"
    Project   = var.PROJECT
    ManagedBy = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_for_bastion" {
  security_group_id = aws_security_group.vprofile-bastion-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_bastion" {
  security_group_id = aws_security_group.vprofile-bastion-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6_bastion" {
  security_group_id = aws_security_group.vprofile-bastion-sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

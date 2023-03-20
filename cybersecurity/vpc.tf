resource "aws_vpc" "CyberSecurity" {
  cidr_block                           = "10.0.0.0/16"
  tags                                 = {
    "Name" = "CyberSecurity"
  }
}

resource "aws_subnet" "subnet_private1" {
  availability_zone                              = var.avail_zone
  cidr_block                                     = "10.0.1.0/24"
  tags                                           = {
    "Name" = "CyberSecurity-subnet-cyber_private1"
  }
  vpc_id                                         = aws_vpc.CyberSecurity.id
}

resource "aws_subnet" "subnet_private2" {
  availability_zone                              = var.avail_zone
  cidr_block                                     = "10.0.2.0/24"
  tags                                           = {
    "Name" = "CyberSecurity-subnet-cyber_private2"
  }
  vpc_id                                         = aws_vpc.CyberSecurity.id
}

resource "aws_subnet" "subnet_private3" {
  availability_zone                              = var.avail_zone
  cidr_block                                     = "10.0.3.0/24"
  tags                                           = {
    "Name" = "CyberSecurity-subnet-cyber_private3"
  }
  vpc_id                                         = aws_vpc.CyberSecurity.id
}

resource "aws_subnet" "subnet_public1" {
  availability_zone                              = var.avail_zone
  cidr_block                                     = "10.0.0.0/24"
  tags                                           = {
    "Name" = "CyberSecurity-subnet-cyber_public1"
  }
  vpc_id                                         = aws_vpc.CyberSecurity.id
}

resource "aws_internet_gateway" "CyberSecurity-igw" {
  tags     = {
    "Name" = "CyberSecurity-igw"
  }
  vpc_id   = aws_vpc.CyberSecurity.id
}

resource "aws_route_table" "rt_private1" {
  tags             = {
    "Name" = "CyberSecurity-rtb-cyber_private1"
  }
  vpc_id           = aws_vpc.CyberSecurity.id
}

resource "aws_route_table" "rt_private2" {
  tags             = {
    "Name" = "CyberSecurity-rtb-cyber_private2"
  }
  vpc_id           = aws_vpc.CyberSecurity.id
}

resource "aws_route_table" "rt_private3" {
  tags             = {
    "Name" = "CyberSecurity-rtb-cyber_private3"
  }
  vpc_id           = aws_vpc.CyberSecurity.id
}

resource "aws_route_table" "rt_public1" {
  vpc_id = aws_vpc.CyberSecurity.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.CyberSecurity-igw.id
  }
  tags             = {
    "Name" = "CyberSecurity-rtb-public"
  }
}

resource "aws_route_table_association" "rta_private1" {
  route_table_id = aws_route_table.rt_private1.id
  subnet_id      = aws_subnet.subnet_private1.id
}

resource "aws_route_table_association" "rta_private2" {
  route_table_id = aws_route_table.rt_private2.id
  subnet_id      = aws_subnet.subnet_private2.id
}

resource "aws_route_table_association" "rta_private3" {
  route_table_id = aws_route_table.rt_private3.id
  subnet_id      = aws_subnet.subnet_private3.id
}

resource "aws_route_table_association" "rta_public1" {
  route_table_id = aws_route_table.rt_public1.id
  subnet_id      = aws_subnet.subnet_public1.id
}

resource "aws_vpc_endpoint" "CyberSecurity-vpce-s3" {
  policy                = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
      Version   = "2008-10-17"
    }
  )
  route_table_ids       = [
    aws_route_table.rt_private1.id,
    aws_route_table.rt_private2.id,
    aws_route_table.rt_private3.id,
  ]
  service_name          = var.vpc_ep_svc_name
  tags                  = {
    "Name" = "CyberSecurity-vpce-s3"
  }
  vpc_endpoint_type     = "Gateway"
  vpc_id                = aws_vpc.CyberSecurity.id
}

resource "aws_security_group" "cyber_default" {
  description = "CyberSecurity default VPC security group"
  egress      = [
    {
      cidr_blocks      = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    },
  ]
  ingress     = [
    {
      cidr_blocks      = [
        "192.168.0.0/16",
        "172.16.0.0/12",
        "10.0.0.0/8",
      ]
      description      = "RFC 1918"
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = true
      to_port          = 0
    },
  ]
  name        = "cyber_default"
  tags        = {
    "Name" = "CyberSecurity"
  }
  vpc_id      = aws_vpc.CyberSecurity.id
}

resource "aws_vpc_security_group_ingress_rule" "cyber_home" {
  cidr_ipv4              = "128.65.243.205/32"
  description            = "Home"
  ip_protocol            = "-1"
  security_group_id      = aws_security_group.cyber_default.id
  tags                   = {
    "Name" = "Home IP address"
  }
  depends_on = [
    aws_security_group.cyber_default
  ]
}

resource "aws_vpc_security_group_ingress_rule" "cyber_nos_enta" {
  cidr_ipv4              = "185.218.12.73/32"
  description            = "ENTA NOS"
  ip_protocol            = "-1"
  security_group_id      = aws_security_group.cyber_default.id
  tags                   = {
    "Name" = "ENTA NOS IP address"
  }
  depends_on = [
    aws_security_group.cyber_default
  ]
}

resource "aws_vpc_security_group_ingress_rule" "cyber_meo_enta" {
  cidr_ipv4              = "83.240.158.54/32"
  description            = "ENTA MEO"
  ip_protocol            = "-1"
  security_group_id      = aws_security_group.cyber_default.id
  tags                   = {
    "Name" = "ENTA MEO IP address"
  }
  depends_on = [
    aws_security_group.cyber_default
  ]
}

resource "aws_key_pair" "CyberSecurity" {
  key_name   = "Redes"
  public_key = var.public_key
}

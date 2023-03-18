resource "aws_key_pair" "CyberSecurity" {
  key_name   = "Redes"
  public_key = var.public_key
}

resource "aws_vpc" "CyberSecurity" {
  cidr_block                           = "10.0.0.0/16"
  tags                                 = {
    "Name" = "CyberSecurity"
  }
}

resource "aws_subnet" "cyber_private1" {
  availability_zone                              = var.avail_zone
  cidr_block                                     = "10.0.1.0/24"
  tags                                           = {
    "Name" = "CyberSecurity-subnet-cyber_private1"
  }
  vpc_id                                         = aws_vpc.CyberSecurity.id
}

resource "aws_subnet" "cyber_private2" {
  availability_zone                              = var.avail_zone
  cidr_block                                     = "10.0.2.0/24"
  tags                                           = {
    "Name" = "CyberSecurity-subnet-cyber_private2"
  }
  vpc_id                                         = aws_vpc.CyberSecurity.id
}

resource "aws_subnet" "cyber_private3" {
  availability_zone                              = var.avail_zone
  cidr_block                                     = "10.0.3.0/24"
  tags                                           = {
    "Name" = "CyberSecurity-subnet-cyber_private3"
  }
  vpc_id                                         = aws_vpc.CyberSecurity.id
}

resource "aws_subnet" "cyber_public1" {
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

resource "aws_route_table" "cyber_private1" {
  tags             = {
    "Name" = "CyberSecurity-rtb-cyber_private1"
  }
  vpc_id           = aws_vpc.CyberSecurity.id
}

resource "aws_route_table" "cyber_private2" {
  tags             = {
    "Name" = "CyberSecurity-rtb-cyber_private2"
  }
  vpc_id           = aws_vpc.CyberSecurity.id
}

resource "aws_route_table" "cyber_private3" {
  tags             = {
    "Name" = "CyberSecurity-rtb-cyber_private3"
  }
  vpc_id           = aws_vpc.CyberSecurity.id
}

resource "aws_route_table" "cyber_public1" {
  vpc_id = aws_vpc.CyberSecurity.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.CyberSecurity-igw.id
  }
  tags             = {
    "Name" = "CyberSecurity-rtb-public"
  }
}

resource "aws_route_table_association" "cyber_private1" {
  route_table_id = aws_route_table.cyber_private1.id
  subnet_id      = aws_subnet.cyber_private1.id
}

resource "aws_route_table_association" "cyber_private2" {
  route_table_id = aws_route_table.cyber_private2.id
  subnet_id      = aws_subnet.cyber_private2.id
}

resource "aws_route_table_association" "cyber_private3" {
  route_table_id = aws_route_table.cyber_private3.id
  subnet_id      = aws_subnet.cyber_private3.id
}

resource "aws_route_table_association" "cyber_public1" {
  route_table_id = aws_route_table.cyber_public1.id
  subnet_id      = aws_subnet.cyber_public1.id
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
    aws_route_table.cyber_private1.id,
    aws_route_table.cyber_private2.id,
    aws_route_table.cyber_private3.id,
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

resource "aws_instance" "desktop" {
  ami                                  = var.desktop_ami
  instance_type                        = var.desktop_type
  key_name                             = aws_key_pair.CyberSecurity.key_name
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.desktop_cyber_public1.id
  }
  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.desktop_cyber_private1.id
  }
  tags                                 = {
    "Name" = "desktop"
  }
  root_block_device {
    delete_on_termination = true
    tags                                 = {
      "Name" = "Volume for desktop"
    }
    volume_size           = 30
    volume_type           = "gp2"
  }
  user_data = data.template_cloudinit_config.config-desktop.rendered
}

resource "aws_network_interface" "desktop_cyber_private1" {
  private_ips         = ["10.0.1.10"]
  security_groups    = [
    aws_security_group.cyber_default.id,
  ]
  source_dest_check  = false
  subnet_id          = aws_subnet.cyber_private1.id
  tags                                 = {
    "Name" = "CyberSecurity private1 interface"
  }
}

resource "aws_network_interface" "desktop_cyber_private2" {
  private_ips         = ["10.0.2.10"]
  security_groups    = [
    aws_security_group.cyber_default.id,
  ]
  source_dest_check  = false
  subnet_id          = aws_subnet.cyber_private2.id
  tags                                 = {
    "Name" = "CyberSecurity private2 interface"
  }
}

resource "aws_network_interface" "desktop_cyber_private3" {
  private_ips         = ["10.0.3.10"]
  security_groups    = [
    aws_security_group.cyber_default.id,
  ]
  source_dest_check  = false
  subnet_id          = aws_subnet.cyber_private3.id
  tags                                 = {
    "Name" = "CyberSecurity private3 interface"
  }
}

resource "aws_network_interface" "desktop_cyber_public1" {
  private_ips         = ["10.0.0.10"]
  security_groups    = [
    aws_security_group.cyber_default.id,
  ]
  source_dest_check  = false
  subnet_id          = aws_subnet.cyber_public1.id
  tags                                 = {
    "Name" = "CyberSecurity public interface"
  }
}

resource "aws_eip" "cyber_public_ip" {
  vpc                       = true
  network_interface         = aws_network_interface.desktop_cyber_public1.id
  tags                                 = {
    "Name" = "CyberSecurity public IP"
  }
  depends_on = [
    aws_instance.desktop
  ]
}

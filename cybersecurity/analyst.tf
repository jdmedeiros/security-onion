resource "aws_instance" "analyst" {
  ami                                  = var.analyst_ami
  instance_type                        = var.analyst_type
  key_name                             = aws_key_pair.CyberSecurity.key_name
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.analyst_nic_public1.id
  }
  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.analyst_nic_private1.id
  }
  tags                                 = {
    "Name" = "analyst"
  }
  root_block_device {
    delete_on_termination = true
    tags                                 = {
      "Name" = "Volume for Analyst"
    }
    volume_size           = 64
    volume_type           = "gp2"
  }
  user_data = data.template_cloudinit_config.config-analyst.rendered
}

resource "aws_network_interface" "analyst_nic_private1" {
  private_ips         = ["10.0.1.12"]
  security_groups    = [
    aws_security_group.cyber_default.id,
  ]
  source_dest_check  = false
  subnet_id          = aws_subnet.subnet_private1.id
  tags                                 = {
    "Name" = "CyberSecurity Analyst private1 interface"
  }
}

resource "aws_network_interface" "analyst_nic_private2" {
  private_ips         = ["10.0.2.12"]
  security_groups    = [
    aws_security_group.cyber_default.id,
  ]
  source_dest_check  = false
  subnet_id          = aws_subnet.subnet_private2.id
  tags                                 = {
    "Name" = "CyberSecurity Analyst private2 interface"
  }
}

resource "aws_network_interface" "analyst_nic_private3" {
  private_ips         = ["10.0.3.12"]
  security_groups    = [
    aws_security_group.cyber_default.id,
  ]
  source_dest_check  = false
  subnet_id          = aws_subnet.subnet_private3.id
  tags                                 = {
    "Name" = "CyberSecurity Analyst private3 interface"
  }
}

resource "aws_network_interface" "analyst_nic_public1" {
  private_ips         = ["10.0.0.12"]
  security_groups    = [
    aws_security_group.cyber_default.id,
  ]
  source_dest_check  = false
  subnet_id          = aws_subnet.subnet_public1.id
  tags                                 = {
    "Name" = "CyberSecurity Analyst public interface"
  }
}

resource "aws_eip" "analyst_public_ip" {
  vpc                       = true
  network_interface         = aws_network_interface.analyst_nic_public1.id
  tags                                 = {
    "Name" = "CyberSecurity Analyst public IP"
  }
  depends_on = [
    aws_instance.analyst
  ]
}

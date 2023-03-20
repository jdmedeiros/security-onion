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
  subnet_id          = aws_subnet.subnet_private1.id
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
  subnet_id          = aws_subnet.subnet_private2.id
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
  subnet_id          = aws_subnet.subnet_private3.id
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
  subnet_id          = aws_subnet.subnet_public1.id
  tags                                 = {
    "Name" = "CyberSecurity public interface"
  }
}

resource "aws_eip" "desktop_public_ip" {
  vpc                       = true
  network_interface         = aws_network_interface.desktop_cyber_public1.id
  tags                                 = {
    "Name" = "CyberSecurity public IP"
  }
  depends_on = [
    aws_instance.desktop
  ]
}

resource "aws_instance" "onion" {
  ami                                  = var.onion_ami
  instance_type                        = var.onion_type
  key_name                             = aws_key_pair.CyberSecurity.key_name
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.desktop_onion_private1.id
  }
  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.desktop_onion_private2.id
  }
  network_interface {
    device_index         = 2
    network_interface_id = aws_network_interface.desktop_onion_private3.id
  }
  tags                                 = {
    "Name" = "onion"
  }
  root_block_device {
    delete_on_termination = true
    tags                                 = {
      "Name" = "Volume for desktop"
    }
    volume_size           = 100
    volume_type           = "gp2"
  }
  user_data = data.template_cloudinit_config.config-onion.rendered
  depends_on = [
    aws_efs_mount_target.onion2-mnt1,
    aws_instance.desktop
  ]
}

resource "aws_network_interface" "desktop_onion_private1" {
  private_ips         = ["10.0.1.11"]
  security_groups    = [
    aws_security_group.cyber_default.id,
  ]
  source_dest_check  = false
  subnet_id          = aws_subnet.cyber_private1.id
  tags                                 = {
    "Name" = "CyberSecurity onion private1 interface"
  }
}

resource "aws_network_interface" "desktop_onion_private2" {
  private_ips         = ["10.0.2.11"]
  security_groups    = [
    aws_security_group.cyber_default.id,
  ]
  source_dest_check  = false
  subnet_id          = aws_subnet.cyber_private2.id
  tags                                 = {
    "Name" = "CyberSecurity onion private2 interface"
  }
}

resource "aws_network_interface" "desktop_onion_private3" {
  private_ips         = ["10.0.3.11"]
  security_groups    = [
    aws_security_group.cyber_default.id,
  ]
  source_dest_check  = false
  subnet_id          = aws_subnet.cyber_private3.id
  tags                                 = {
    "Name" = "CyberSecurity onion private3 interface"
  }
}

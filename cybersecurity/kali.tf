resource "aws_instance" "kali" {
  ami                                  = var.kali_ami
  instance_type                        = var.kali_type
  key_name                             = aws_key_pair.CyberSecurity.key_name
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.kali_nic_public1.id
  }
  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.kali_nic_private1.id
  }
  tags                                 = {
    "Name" = "kali"
  }
  root_block_device {
    delete_on_termination = true
    tags                                 = {
      "Name" = "Volume for kali"
    }
    volume_size           = 64
    volume_type           = "gp2"
  }
  user_data = data.template_cloudinit_config.config-kali.rendered
}

resource "aws_network_interface" "kali_nic_private1" {
  private_ips         = ["10.0.1.12"]
  security_groups    = [
    aws_security_group.cyber_default.id,
  ]
  source_dest_check  = false
  subnet_id          = aws_subnet.subnet_private1.id
  tags                                 = {
    "Name" = "CyberSecurity kali private1 interface"
  }
}

resource "aws_network_interface" "kali_nic_private2" {
  private_ips         = ["10.0.2.12"]
  security_groups    = [
    aws_security_group.cyber_default.id,
  ]
  source_dest_check  = false
  subnet_id          = aws_subnet.subnet_private2.id
  tags                                 = {
    "Name" = "CyberSecurity kali private2 interface"
  }
}

resource "aws_network_interface" "kali_nic_private3" {
  private_ips         = ["10.0.3.12"]
  security_groups    = [
    aws_security_group.cyber_default.id,
  ]
  source_dest_check  = false
  subnet_id          = aws_subnet.subnet_private3.id
  tags                                 = {
    "Name" = "CyberSecurity kali private3 interface"
  }
}

resource "aws_network_interface" "kali_nic_public1" {
  private_ips         = ["10.0.0.12"]
  security_groups    = [
    aws_security_group.cyber_default.id,
  ]
  source_dest_check  = false
  subnet_id          = aws_subnet.subnet_public1.id
  tags                                 = {
    "Name" = "CyberSecurity kali public interface"
  }
}

resource "aws_eip" "kali_public_ip" {
  vpc                       = true
  network_interface         = aws_network_interface.kali_nic_public1.id
  tags                                 = {
    "Name" = "CyberSecurity kali public IP"
  }
  depends_on = [
    aws_instance.kali
  ]
}

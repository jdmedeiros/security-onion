resource "aws_instance" "sift" {
  ami                                  = var.sift_ami
  instance_type                        = var.sift_type
  key_name                             = aws_key_pair.CyberSecurity.key_name
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.sift_nic_public1.id
  }
  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.sift_nic_private1.id
  }
  tags                                 = {
    "Name" = "sift"
  }
  root_block_device {
    delete_on_termination = true
    tags                                 = {
      "Name" = "Volume for sift"
    }
    volume_size           = 100
    volume_type           = "gp2"
  }
  user_data = data.template_cloudinit_config.config-sift.rendered
}

resource "aws_network_interface" "sift_nic_private1" {
  private_ips         = ["10.0.1.14"]
  security_groups    = [
    aws_security_group.cyber_default.id,
  ]
  source_dest_check  = false
  subnet_id          = aws_subnet.subnet_private1.id
  tags                                 = {
    "Name" = "CyberSecurity sift private1 interface"
  }
}

resource "aws_network_interface" "sift_nic_private2" {
  private_ips         = ["10.0.2.14"]
  security_groups    = [
    aws_security_group.cyber_default.id,
  ]
  source_dest_check  = false
  subnet_id          = aws_subnet.subnet_private2.id
  tags                                 = {
    "Name" = "CyberSecurity sift private2 interface"
  }
}

resource "aws_network_interface" "sift_nic_private3" {
  private_ips         = ["10.0.3.14"]
  security_groups    = [
    aws_security_group.cyber_default.id,
  ]
  source_dest_check  = false
  subnet_id          = aws_subnet.subnet_private3.id
  tags                                 = {
    "Name" = "CyberSecurity sift private3 interface"
  }
}

resource "aws_network_interface" "sift_nic_public1" {
  private_ips         = ["10.0.0.14"]
  security_groups    = [
    aws_security_group.cyber_default.id,
  ]
  source_dest_check  = false
  subnet_id          = aws_subnet.subnet_public1.id
  tags                                 = {
    "Name" = "CyberSecurity sift public interface"
  }
}

resource "aws_eip" "sift_public_ip" {
  vpc                       = true
  network_interface         = aws_network_interface.sift_nic_public1.id
  tags                                 = {
    "Name" = "CyberSecurity sift public IP"
  }
  depends_on = [
    aws_instance.sift
  ]
}

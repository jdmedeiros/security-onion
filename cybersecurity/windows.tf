resource "aws_instance" "winsrv" {
  ami                                  = var.windows_ami
  instance_type                        = "t2.small"
  key_name                             = aws_key_pair.CyberSecurity.key_name
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.winsrv_public1.id
  }
  tags                                 = {
    "Name" = "winsrv"
  }
  root_block_device {
    delete_on_termination = true
    tags                                 = {
      "Name" = "Volume for winsrv"
    }
    volume_size           = 64
    volume_type           = "gp2"
  }
  user_data = data.template_file.winsrv.rendered
}

resource "aws_network_interface" "winsrv_private1" {
  private_ips         = ["10.0.1.10"]
  security_groups    = [
    aws_security_group.cyber_default.id,
  ]
  source_dest_check  = false
  subnet_id          = aws_subnet.subnet_private1.id
  tags                                 = {
    "Name" = "Windows private1 interface"
  }
  attachment {
    device_index  = 1
    instance      = aws_instance.winsrv.id
  }
}

resource "aws_network_interface" "winsrv_public1" {
  private_ips         = ["10.0.0.10"]
  security_groups    = [
    aws_security_group.cyber_default.id
  ]
  source_dest_check  = false
  subnet_id          = aws_subnet.subnet_public1.id
  tags                                 = {
    "Name" = "Windows public interface"
  }
}

resource "aws_eip" "winsrv_public_ip" {
  vpc                       = true
  network_interface         = aws_network_interface.winsrv_public1.id
  tags                                 = {
    "Name" = "Windows public IP"
  }
  depends_on = [
    aws_instance.winsrv
  ]
}

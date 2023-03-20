terraform {
  required_version = ">= 1.3.9"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 4.56.0"
    }
    cloudinit = {
      source = "hashicorp/cloudinit"
      version = "2.3.2"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  #access_key = "xxxx"
  #secret_key = "xxxx"
  #token = "xxxx"

  profile = "vocareum"
}

provider "cloudinit" {
}

data "template_cloudinit_config" "config-desktop" {
  gzip = false
  base64_encode = false

  part {
    filename = var.cloud_config_desktop
    content_type = "text/x-shellscript"
    content = file(var.cloud_config_desktop)
  }

  part {
    filename = var.config-desktop
    content_type = "text/x-shellscript"
    content = file(var.config-desktop)
  }

  part {
    filename = var.config-onion
    content_type = "text/x-shellscript"
    content = file(var.config-onion)
  }
}

data "template_file" "script" {
  template = file("${path.module}/update-fstab.tpl")

  vars = {
    onion_ip = aws_network_interface.onion_nic_private1.private_ip,
    efs_ip = aws_efs_mount_target.onion2-mnt1.ip_address
  }
}

data "template_cloudinit_config" "config-onion" {
  gzip = false
  base64_encode = false

  part {
    filename     = "update-fstab.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.script.rendered
  }

  part {
    filename = var.cloud_config_onion
    content_type = "text/x-shellscript"
    content = file(var.cloud_config_onion)
  }

  part {
    filename = var.config-onion
    content_type = "text/x-shellscript"
    content = file(var.config-onion)
  }

  part {
    filename = var.config-netplan
    content_type = "text/x-shellscript"
    content = file(var.config-netplan)
  }
}

data "template_cloudinit_config" "config-kali" {
  gzip = false
  base64_encode = false

  part {
    filename = var.cloud_config_kali
    content_type = "text/x-shellscript"
    content = file(var.config-kali)
  }

  part {
    filename = var.config-desktop
    content_type = "text/x-shellscript"
    content = file(var.config-desktop)
  }

  part {
    filename = var.config-onion
    content_type = "text/x-shellscript"
    content = file(var.config-onion)
  }
}
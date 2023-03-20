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
    filename     = var.desktop-change-password
    content_type = "text/x-shellscript"
    content      = data.template_file.desktop-password.rendered
  }

  part {
    filename = var.cloud-config-desktop
    content_type = "text/x-shellscript"
    content = file(var.cloud-config-desktop)
  }

  part {
    filename = var.config-desktop
    content_type = "text/x-shellscript"
    content = file(var.config-desktop)
  }

  part {
    filename = var.config-NetworkMiner
    content_type = "text/x-shellscript"
    content = file(var.config-NetworkMiner)
  }

  part {
    filename = var.config-onion
    content_type = "text/x-shellscript"
    content = file(var.config-onion)
  }

  part {
    filename = var.config-45-allow-colord
    content_type = "text/plain"
    content = file(var.config-45-allow-colord)
  }
}

data "template_file" "fstab" {
  template = file("${path.module}/update-fstab.tpl")

  vars = {
    onion_ip = aws_network_interface.onion_nic_private1.private_ip,
    efs_ip = aws_efs_mount_target.onion2-mnt1.ip_address
  }
}

data "template_file" "kali-password" {
  template = file("${path.module}/kali-change-password.tpl")

  vars = {
    userid = "kali",
    userpw = var.kali_userpw
  }
}

data "template_file" "desktop-password" {
  template = file("${path.module}/desktop-change-password.tpl")

  vars = {
    userid = "ubuntu",
    userpw = var.desktop_userpw
  }
}

data "template_cloudinit_config" "config-onion" {
  gzip = false
  base64_encode = false

  part {
    filename     = var.update-fstab
    content_type = "text/x-shellscript"
    content      = data.template_file.fstab.rendered
  }

  part {
    filename = var.cloud-config-onion
    content_type = "text/x-shellscript"
    content = file(var.cloud-config-onion)
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

  part {
    filename = var.config-NetworkMiner
    content_type = "text/x-shellscript"
    content = file(var.config-NetworkMiner)
  }
  part {
    filename = var.config-45-allow-colord
    content_type = "text/plain"
    content = file(var.config-45-allow-colord)
  }
}

data "template_cloudinit_config" "config-kali" {
  gzip = false
  base64_encode = false

  part {
    filename     = var.kali-change-password
    content_type = "text/x-shellscript"
    content      = data.template_file.kali-password.rendered
  }

  part {
    filename = var.cloud-config-kali
    content_type = "text/x-shellscript"
    content = file(var.cloud-config-kali)
  }

  part {
    filename = var.config-kali
    content_type = "text/x-shellscript"
    content = file(var.config-kali)
  }

  part {
    filename = var.config-NetworkMiner
    content_type = "text/x-shellscript"
    content = file(var.config-NetworkMiner)
  }

  part {
    filename = var.config-45-allow-colord
    content_type = "text/plain"
    content = file(var.config-45-allow-colord)
  }
}
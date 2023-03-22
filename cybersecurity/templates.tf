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

data "template_file" "sift-password" {
  template = file("${path.module}/sift-change-password.tpl")

  vars = {
    userid = "sansforensics",
    userpw = var.sift_userpw
  }
}


data "template_file" "remnux-password" {
  template = file("${path.module}/remnux-change-password.tpl")

  vars = {
    userid = "remnux",
    userpw = var.remnux_userpw
  }
}

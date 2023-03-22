variable "desktop_ami" {
  type = string
  default = "ami-0557a15b87f6559cf"
}

variable "desktop_type" {
  type = string
  default = "t2.small"
}

variable "desktop_userpw" {
  description = "Insert the pasword for the user ubuntu"
  type = string
  sensitive   = true
}

variable "cloud-config-desktop" {
  default = "cloud-config-desktop.sh"
}

variable "config-desktop" {
  default = "config-desktop.sh"
}

variable "desktop-change-password" {
  default = "desktop-change-password.sh"
}

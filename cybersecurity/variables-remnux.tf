variable "remnux_ami" {
  type = string
  default = "ami-00118dd8add6c7104"
}

variable "remnux_type" {
  type = string
  default = "m5.large"
}

variable "remnux_userpw" {
  description = "Insert the pasword for the user remnux"
  type = string
  sensitive   = true
}

variable "cloud-config-remnux" {
  default = "cloud-config-remnux.sh"
}

variable "config-remnux" {
  default = "config-remnux.sh"
}

variable "remnux-change-password" {
  default = "remnux-change-password.sh"
}

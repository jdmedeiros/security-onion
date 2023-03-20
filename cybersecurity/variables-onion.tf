variable "onion_ami" {
type = string
default = "ami-09cd747c78a9add63"
}

variable "onion_type" {
  type = string
  default = "m5.large"
}

variable "cloud-config-onion" {
  default = "cloud-config-onion.sh"
}

variable "config-onion" {
  default = "config-onion.sh"
}

variable "update-fstab" {
default = "update-fstab.sh.sh"
}

variable "config-netplan" {
  default = "50-cloud-init.yaml.patch"
}

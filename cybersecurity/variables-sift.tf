variable "sift_ami" {
  type = string
  default = "ami-0428a08aa86743ee8"
}

variable "sift_type" {
  type = string
  default = "m5.large"
}

variable "sift_userpw" {
  description = "Insert the pasword for the user sift"
  type = string
  sensitive   = true
}

variable "cloud-config-sift" {
  default = "cloud-config-sift.sh"
}

variable "config-sift" {
  default = "config-sift.sh"
}

variable "sift-change-password" {
  default = "sift-change-password.sh"
}

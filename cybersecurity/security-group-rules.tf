resource "aws_vpc_security_group_ingress_rule" "cyber_home" {
  cidr_ipv4              = "128.65.243.205/32"
  description            = "Home"
  ip_protocol            = "-1"
  security_group_id      = aws_security_group.cyber_default.id
  tags                   = {
    "Name" = "Home IP address"
  }
  depends_on = [
    aws_security_group.cyber_default
  ]
}

resource "aws_vpc_security_group_ingress_rule" "cyber_nos_enta" {
  cidr_ipv4              = "185.218.12.73/32"
  description            = "ENTA NOS"
  ip_protocol            = "-1"
  security_group_id      = aws_security_group.cyber_default.id
  tags                   = {
    "Name" = "ENTA NOS IP address"
  }
  depends_on = [
    aws_security_group.cyber_default
  ]
}

resource "aws_vpc_security_group_ingress_rule" "cyber_meo_enta" {
  cidr_ipv4              = "83.240.158.54/32"
  description            = "ENTA MEO"
  ip_protocol            = "-1"
  security_group_id      = aws_security_group.cyber_default.id
  tags                   = {
    "Name" = "ENTA MEO IP address"
  }
  depends_on = [
    aws_security_group.cyber_default
  ]
}

# Some sanity checking to make sure we are in the right account - very important if you use multiple accounts

data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

output "eip_onion" {
  value = aws_eip.onion_public_ip.public_ip
}

output "eip_kali" {
  value = aws_eip.kali_public_ip.public_ip
}

output "eip_remnux" {
  value = aws_eip.remnux_public_ip.public_ip
}

output "eip_sift" {
  value = aws_eip.sift_public_ip.public_ip
}

output "eip_windows" {
  value = aws_eip.winsrv_public_ip.public_ip
}

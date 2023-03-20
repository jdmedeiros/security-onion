resource "aws_efs_file_system" "onion2-efs" {
  creation_token                  = "Onion2ServerToken"
  encrypted                       = true
  tags                            = {
    "Name" = "Onion2 EFS"
  }
}

resource "aws_efs_access_point" "onion2-ap" {
  file_system_id  = aws_efs_file_system.onion2-efs.id
  tags            = {
    "Name" = "Onion2 AP"
  }

  posix_user {
    gid            = 1001
    secondary_gids = [
      0,
    ]
    uid            = 1001
  }

  root_directory {
    path = "/"
  }
}

resource "aws_efs_mount_target" "onion2-mnt1" {
  file_system_id         = aws_efs_file_system.onion2-efs.id
  security_groups        = [
    aws_security_group.cyber_default.id,
  ]
  subnet_id              = aws_subnet.subnet_private1.id
}

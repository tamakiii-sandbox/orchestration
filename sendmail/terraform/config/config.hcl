name = "sendmail"
vpc_cidr_block = "10.0.0.0/16"
ec2_key_pair_name = "d-tamaki-m.voyagegroup.local"

availability_zones = {
  alpha = "ap-northeast-1a"
  charlie = "ap-northeast-1c"
}

subnet_cidr_blocks = {
  alpha = "10.0.0.0/24"
  charlie = "10.0.2.0/24"
}

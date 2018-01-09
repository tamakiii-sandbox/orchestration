########################################
# Variables
########################################
variable "name" {
  default = "tfawsecs"
}
variable "profile" {
  default = "tamakiii"
}
variable "region" {
  default = "ap-northeast-1"
}
variable "availability_zones" {
  type = "map"
  default = {
    alpha    = "ap-northeast-1a"
    beta     = "ap-northeast-1b"
    charlie  = "ap-northeast-1c"
    delta    = "ap-northeast-1d"
  }
}
variable "vpc_cidr_block" {
  default = "11.0.0.0/16"
}
variable "subnet_cidr_blocks" {
  type = "map"
  default = {
    alpha    = "11.0.1.0/24"
    beta     = "11.0.2.0/24"
    charlie  = "11.0.3.0/24"
    delta    = "11.0.4.0/24"
  }
}

variable "key_pair" { type = "map" }

########################################
# Backend
########################################
terraform {
  backend "s3" {
    region = "ap-northeast-1"
    bucket = "terraform.tamakiii.com"
    key = "orchestration/tf-aws-ecs/terraform.tfstate"
  }
}

########################################
# Provider
########################################
provider "aws" {
  version = "~> 1.6"
  profile = "${var.profile}"
  region = "${var.region}"
}


########################################
# Resources
########################################
resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr_block}"
  instance_tenancy = "default"

  enable_dns_support = true
  enable_dns_hostnames = true
  enable_classiclink = false

  tags {
    Name = "${var.name}"
  }
}

resource "aws_subnet" "alpha" {
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "${var.availability_zones["alpha"]}"
  cidr_block = "${var.subnet_cidr_blocks["alpha"]}"

  tags {
    Name = "${var.name}-alpha"
  }

  depends_on = ["aws_vpc.main"]
}
resource "aws_subnet" "charlie" {
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "${var.availability_zones["charlie"]}"
  cidr_block = "${var.subnet_cidr_blocks["charlie"]}"

  tags {
    Name = "${var.name}-charlie"
  }

  depends_on = ["aws_vpc.main"]
}

resource "aws_internet_gateway" "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.name}"
  }

  depends_on = ["aws_vpc.main"]
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.public.id}"
  }

  tags {
    Name = "${var.name}"
  }

  depends_on = ["aws_internet_gateway.public"]
}

resource "aws_route_table_association" "alpha" {
  subnet_id = "${aws_subnet.alpha.id}"
  route_table_id = "${aws_route_table.public.id}"

  depends_on = ["aws_subnet.alpha", "aws_route_table.public"]
}
resource "aws_route_table_association" "charlie" {
  subnet_id = "${aws_subnet.charlie.id}"
  route_table_id = "${aws_route_table.public.id}"

  depends_on = ["aws_subnet.charlie", "aws_route_table.public"]
}

resource "aws_key_pair" "main" {
  key_name = "${var.key_pair["key_name"]}"
  public_key = "${var.key_pair["public_key"]}"
}

# variable "ecs_ami" {
#   default = "ami-56bd0030"
# }

resource "aws_security_group" "ecs" {
  vpc_id      = "${aws_vpc.main.id}"
  name        = "${var.name}-ecs"
  description = "ecs security group"

  ingress {
    protocol = "tcp"
    from_port = "80"
    to_port = "80"
  }

  tags {
    Name = "ecs"
  }
}

# resource "aws_security_group" "lb" {
#   vpc_id      = "${aws_vpc.main.id}"
#   name        = "lb"
#   description = "loadbalancer security group"
#
#   tags {
#     Service = "${var.name}"
#     Name    = "${var.name}"
#   }
# }
#
# data "template_file" "cloud_config" {
#   template = "${file("template/cloud_config.tpl.yaml")}"
#
#   vars {
#     aws_region         = "${var.region}"
#     ecs_cluster_name   = "${var.name}"
#     ecs_log_level      = "info"
#     ecs_agent_version  = "latest"
#     ecs_log_group_name = "cluster/ecs-agent"
#   }
# }


# data "aws_ami" "main" {
#   most_recent      = false
#
#   executable_users = ["self"]
#
#   filter {
#     name   = "owner-alias"
#     values = ["amazon"]
#   }
#
#   filter {
#     name   = "name"
#     values = ["amzn-ami-vpc-nat*"]
#   }
#
#   name_regex = "^myami-\\d{3}"
#   owners     = ["self"]
# }

resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.main.id}"
}

data "template_file" "ecs_user_data" {
  template = "${file("template/ecs_user_data.tpl.yaml")}"

  vars {
    aws_region         = "${var.region}"
    ecs_cluster_name   = "${var.name}"
    ecs_log_level      = "info"
    ecs_agent_version  = "latest"
    ecs_log_group_name = "${var.name}/ecs_agent"
  }
}

/**
 * try using tf_aws_ecs(cluster)
 */
module "ecs_cluster" {
  source = "git@github.com:voyagegroup/tf_aws_ecs?ref=v0.1.2//cluster"
  name = "${var.name}"

  log_group = "${var.name}/ecs_agent"
  log_groups_expiration_days = 14

  asg_enabled_metrics = [
    "GroupDesiredCapacity",
    "GroupStandbyInstances",
  ]

  # launch_configuration  = "" // TODO
  asg_termination_policies = [
    "OldestInstance"
  ]

  asg_min_size = 2
  asg_max_size = 6

  vpc_zone_identifier = [
    "${var.availability_zones["alpha"]}",
    "${var.availability_zones["charlie"]}",
  ]

  asg_default_cooldown = 150

  # asg_extra_tags = []

  security_groups = [
    "${aws_security_group.ecs.id}"
  ]

  key_name = "${aws_key_pair.main.key_name}"
  # ami_id = "${data.aws_ami.api.id}"
  ami_id = "ami-56bd0030"
  instance_type = "t2.medium"
  ebs_optimized = false
  user_data = "${data.template_file.ecs_user_data.rendered}"

  associate_public_ip_address = false
}

# output "ecs_cluster" {
#   value = <<EOF
#   name: ${module.ecs_cluster.cluster_name}
#   arn:  ${module.ecs_cluster.cluster_id}
#   security_group:
#     ${aws_security_group.api_ecs.name}:
#       id:   ${aws_security_group.api_ecs.id}
#       desc: ${aws_security_group.api_ecs.description}
# EOF
# }
#
# module "ecs_cluster" {
#   source                       = "git@github.com:voyagegroup/tf_aws_ecs?ref=v0.1.0//cluster"
#   name                         = "${var.name}"
#
#   key_name                     = "${aws_key_pair.main.key_name}"
#   ami_id                       = "${data.aws_ami.main.id}"
#   vpc_zone_identifier          = [
#     "${module.api_private_route.subnet_left_id}",
#     "${module.api_private_route.subnet_right_id}",
#   ]
#   security_groups              = ["${aws_security_group.api_ecs.id}"]
#   instance_type                = "c4.large"
#   ebs_optimized                = true
#   user_data                    = "${data.template_file.api_cloud_config.rendered}"
#
#   asg_min_size                 = 2
#   asg_max_size                 = 20
#   asg_default_cooldown         = 150
#   asg_enabled_metrics          = ["GroupDesiredCapacity"]
#   asg_termination_policies     = ["OldestInstance"]
#   asg_extra_tags               = [
#     {
#       key                 = "Name"
#       value               = "api-ecs"
#       propagate_at_launch = true
#     }
#   ]
#
#   log_group                    = "${var.api_cluster_log_group}"
#   log_groups_expiration_days   = 7
#
#   // [Option] AutoScaling
#   autoscale_notification_ok_topic_arn = "${aws_sns_topic.fluct_syslog.arn}"
#   autoscale_notification_ng_topic_arn = "${aws_sns_topic.fluct_emg.arn}"
#   autoscale_period                    = 180
#   autoscale_thresholds                = {
#     cpu_reservation_high    = 75
#     cpu_reservation_low     = 10
#     memory_reservation_high = 80
#     memory_reservation_low  = 20
#   }
#   scale_out_more_alarm_actions = ["${aws_sns_topic.fluct_syslog.arn}"]
# }
#
# resource "aws_security_group" "api_ecs" {
#   vpc_id      = "${module.api_vpc.id}"
#   name        = "api_ecs"
#   description = "api ecs security_group"
#
#   tags {
#     Name = "api_ecs"
#   }
# }
#
# # using container and dynamic ports
# resource "aws_security_group_rule" "api_ecs_dinamic_ports" {
#   security_group_id        = "${aws_security_group.api_ecs.id}"
#   type                     = "ingress"
#   protocol                 = "tcp"
#   from_port                = 0
#   to_port                  = 65535
#   source_security_group_id = "${aws_security_group.api_lb.id}"
# }
#
# resource "aws_security_group_rule" "api_ecs_engress_allow_all" {
#   security_group_id = "${aws_security_group.api_ecs.id}"
#   type              = "egress"
#   protocol          = "-1"
#   from_port         = 0
#   to_port           = 0
#   cidr_blocks       = ["0.0.0.0/0"]
# }
#
#
# data "aws_ami" "api" {
#   most_recent = true
#
#   filter {
#     name   = "name"
#     values = ["CoreOS x86_64 HVM SR-IOV with cloud-init - *"]
#   }
#   filter {
#     name   = "architecture"
#     values = ["x86_64"]
#   }
#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
#   owners = ["${var.AWS_ACCOUNT_ID_SRE}"]
# }
#
# data "template_file" "api_cloud_config" {
#   template = "${file("api_cloud_config.tpl.yaml")}"
#
#   vars {
#     aws_region         = "${var.AWS_DEFAULT_REGION}"
#     ecs_cluster_name   = "${var.api_cluster_name}"
#     ecs_log_level      = "info"
#     ecs_agent_version  = "latest"
#     ecs_log_group_name = "${var.api_cluster_log_group}"
#   }
# }

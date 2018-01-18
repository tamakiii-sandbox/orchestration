#--------------------------------------------------------------
# VPC
#--------------------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block = "${var.CIDR_BLOCK}"
  instance_tenancy = "default"

  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = false

  tags {
    Name = "${var.name}"
  }
}

#--------------------------------------------------------------
# Security Group - default
#--------------------------------------------------------------
resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.name}"
  }
}

#--------------------------------------------------------------
# Subnet
#--------------------------------------------------------------
resource "aws_subnet" "public_a" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.CIDR_BLOCKS["public_a"]}"
  availability_zone = "${var.AWS_AZ_ALPHA}"

  tags {
    Name = "${var.name}-public-a"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.CIDR_BLOCKS["public_c"]}"
  availability_zone = "${var.AWS_AZ_CHARLIE}"

  tags {
    Name = "${var.name}-public-c"
  }
}

#--------------------------------------------------------------
# Internet Gateway
#--------------------------------------------------------------
resource "aws_internet_gateway" "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.name}-public"
  }
}

#--------------------------------------------------------------
# Route Table
#--------------------------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.public.id}"
  }

  tags {
    Name = "${var.name}-public"
  }
}
resource "aws_route_table_association" "public_a" {
  route_table_id = "${aws_route_table.public.id}"
  subnet_id = "${aws_subnet.public_a.id}"
}
resource "aws_route_table_association" "public_c" {
  route_table_id = "${aws_route_table.public.id}"
  subnet_id = "${aws_subnet.public_c.id}"
}

#--------------------------------------------------------------
# Key Pair
#--------------------------------------------------------------
resource "aws_key_pair" "developer" {
  key_name   = "symfony-4.0-developer.pem"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4XkmsvrZ/8UUXFyqB6JcClRLVXa0bgfPScj4ueMgFvNrVmUJyZsIUnoBAg+8o8ZU/MsWNH/M94TY/3ryFFEmuSC8FQjGVuGAhivil/9IBaPauV7ihNAQcGy6dSe5LmEP+qjMaGJavds93pJXcANmvhodvFSgXfvga80RdJ4pMjX7bPCYnzjCCwA1Eht4e2Y6hKCPrX2Khq6pHPEc3bjRQ8Ut8MBnHzPzq/iPH6rT8+HhfJN81fuwXqWqzarY9+4u1zN+P3akIXPNJ3yoir6aKWFOHlOdGBhRIlVThjiExRsrdhM+wEqLAlz3R67whkQtK/PsNrZrm2WE0pmvVxB6awo6LZqX2afxfRoSMw3Ay+tIIwRlAEDrGhQ3GsW0xfNMwe0jbOrHWfzFqas35QEH8+0s9xzffnarLq6VOU7J8FQ+SfPjFmFRHGmy3M0whGPLAk9zjpq7rzAqo7YfjzSe89UGrAIvRYV3Qwa/BPnKXdDKoWjGAP3KUvEfLeCFauv/O7ka+3j9yNxuKmUZp0sVNuIyJ2ds5SkIYpvf32vvmDHY9tDQiCQCYn3xeleImEQF3vfsQ2h6r9Knliag6GNhMEnoBEpzMD12ZfW34Hqn9e9ASJU43hYfjuG+l24xtIccQWMv3gUJSjG9txXb3SETBd+e4yOCKYZFXtWX0LCQYaw== tamakiii"
}

#--------------------------------------------------------------
# Security Group - ALB
#--------------------------------------------------------------
resource "aws_security_group" "alb" {
  name        = "ALB security group"
  description = "Allow request from internet"
  vpc_id      = "${aws_vpc.main.id}"

  tags {
    Name = "${var.name}-alb"
  }
}
resource "aws_security_group_rule" "alb_ingress_http" {
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.alb.id}"
}
resource "aws_security_group_rule" "alb_egress_all_traffic" {
  type            = "egress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.alb.id}"
}


#--------------------------------------------------------------
# Security Group - ECS
#--------------------------------------------------------------
resource "aws_security_group" "ecs" {
  name        = "ECS security group"
  description = "Allow ECS ports"
  vpc_id      = "${aws_vpc.main.id}"

  tags {
    Name = "${var.name}-ecs"
  }
}
resource "aws_security_group_rule" "ecs_egress_all_traffic" {
  type            = "egress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.ecs.id}"
}
resource "aws_security_group_rule" "ecs_ingress_dynamic_ports" {
  type            = "ingress"
  from_port       = 0
  to_port         = 65535
  protocol        = "tcp"

  security_group_id = "${aws_security_group.ecs.id}"
  source_security_group_id = "${aws_security_group.alb.id}"
}

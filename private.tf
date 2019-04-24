resource "aws_subnet" "private" {
  count             = "${var.subnet_count}"
  vpc_id            = "${aws_vpc.vpc.id}"
  availability_zone = "${element(slice(data.aws_availability_zones.available.names, 0, var.subnet_count), count.index)}"
  cidr_block        = "${cidrsubnet(var.vpc_cidr_block, ceil(log(var.subnet_count * 2, 2)), count.index)}"

  tags {
    Name = "${element(slice(data.aws_availability_zones.available.names, 0, var.subnet_count), count.index)}-${var.app_name_short}-${var.environment}-sn-private"
    Application = "${var.app_name_long}"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table" "private" {
  count  = "${var.subnet_count}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${element(slice(data.aws_availability_zones.available.names, 0, var.subnet_count), count.index)}-${var.app_name_short}-${var.environment}-rt-private"
    Application = "${var.app_name_long}"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "private" {
  count = "${var.subnet_count}"

  subnet_id      = "${aws_subnet.private.*.id[count.index]}"
  route_table_id = "${aws_route_table.private.*.id[count.index]}"
}

resource "aws_network_acl" "private" {
  vpc_id = "${aws_vpc.vpc.id}"
  subnet_ids = ["${aws_subnet.private.*.id}"]

  egress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  tags = {
    Name = "${var.region}-${var.app_name_short}-${var.environment}-nacl-private"
    Application = "${var.app_name_long}"
    Environment = "${var.environment}"
  }
}

# resource "aws_network_acl_rule" "private_ingress" {
#   count          = "${var.subnet_count}"
#   network_acl_id = "${aws_network_acl.private.id}"
#   rule_number    = "${(count.index + 1) * 100}"
#   egress         = false
#   protocol       = "tcp"
#   rule_action    = "allow"
#   cidr_block     = "${module.dynamic_subnets.public_subnet_cidrs[count.index]}"
#   from_port      = "${var.alb_target_port}"
#   to_port        = "${var.alb_target_port}"
# }


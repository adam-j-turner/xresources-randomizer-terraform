resource "aws_subnet" "public" {
  count             = "${var.subnet_count}"
  vpc_id            = "${aws_vpc.vpc.id}"
  availability_zone = "${element(slice(data.aws_availability_zones.available.names, 0, var.subnet_count), count.index)}"
  cidr_block        = "${cidrsubnet(var.vpc_cidr_block, ceil(log(var.subnet_count * 2, 2)), var.subnet_count + count.index)}"

  tags {
    Name = "${element(slice(data.aws_availability_zones.available.names, 0, var.subnet_count), count.index)}-${var.app_name_short}-${var.environment}-sn-public"
    Application = "${var.app_name_long}"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.region}-${var.app_name_short}-${var.environment}-rt-public"
    Application = "${var.app_name_long}"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "public" {
  count = "${var.subnet_count}"

  subnet_id      = "${aws_subnet.public.*.id[count.index]}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route" "public" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

resource "aws_network_acl" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  subnet_ids = ["${aws_subnet.public.*.id}"]

  egress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  ingress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.vpc_cidr_block}"
    from_port  = "${var.alb_listen_port}"
    to_port    = "${var.alb_listen_port}"
    protocol   = "tcp"
  }

  tags = {
    Name = "${var.region}-${var.app_name_short}-${var.environment}-nacl-public"
    Application = "${var.app_name_long}"
    Environment = "${var.environment}"
  }
}


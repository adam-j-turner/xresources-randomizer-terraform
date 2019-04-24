resource "aws_eip" "ngw" {
  count = "${var.subnet_count}"
  vpc   = true

  tags {
    Name = "${element(slice(data.aws_availability_zones.available.names, 0, var.subnet_count), count.index)}-${var.app_name_short}-${var.environment}-ngw-eip"
    Application = "${var.app_name_long}"
    Environment = "${var.environment}"
  }
}

resource "aws_nat_gateway" "ngw" {
  count = "${var.subnet_count}"
  allocation_id = "${aws_eip.ngw.*.id[count.index]}"
  subnet_id     = "${aws_subnet.public.*.id[count.index]}"

  tags {
    Name = "${element(slice(data.aws_availability_zones.available.names, 0, var.subnet_count), count.index)}-${var.app_name_short}-${var.environment}-ngw"
    Application = "${var.app_name_long}"
    Environment = "${var.environment}"
  }
}

resource "aws_route" "ngw" {
  count                  = "${var.subnet_count}"
  route_table_id         = "${aws_route_table.private.*.id[count.index]}"
  nat_gateway_id         = "${aws_nat_gateway.ngw.*.id[count.index]}"
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = ["aws_route_table.private"]
}

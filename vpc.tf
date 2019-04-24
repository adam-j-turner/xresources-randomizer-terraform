data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr_block}"

  tags {
    Name = "${var.region}-${var.app_name_short}-${var.environment}-vpc"
    Application = "${var.app_name_long}"
    Environment = "${var.environment}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.region}-${var.app_name_short}-${var.environment}-igw"
    Application = "${var.app_name_long}"
    Environment = "${var.environment}"
  }
}

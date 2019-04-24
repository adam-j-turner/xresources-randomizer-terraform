resource "aws_security_group" "alb_sg" {
  name = "${var.region}-${var.app_name_short}-${var.environment}-alb-sg"
  description = "Controls access to the application ALB"

  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    protocol    = "tcp"
    from_port   = "${var.alb_listen_port}"
    to_port     = "${var.alb_listen_port}"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.region}-${var.app_name_short}-${var.environment}-alb-sg"
    Application = "${var.app_name_long}"
    Environment = "${var.environment}"
  }
}

resource "aws_alb_target_group" "main" {
  name = "${var.region}-${var.app_name_short}-${var.environment}-alb-tg"
  port     = "${var.alb_target_port}"
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.vpc.id}"

  tags {
    Application = "${var.app_name_long}"
    Environment = "${var.environment}"
  }
}

resource "aws_alb" "main" {
  name = "${var.region}-${var.app_name_short}-${var.environment}-alb"
  subnets         = ["${aws_subnet.public.*.id}"]
  security_groups = ["${aws_security_group.alb_sg.id}"]

  tags {
    Application = "${var.app_name_long}"
    Environment = "${var.environment}"
  }
}

resource "aws_alb_listener" "main" {
  load_balancer_arn = "${aws_alb.main.arn}"
  port              = "${var.alb_listen_port}"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.main.arn}"
  }
}

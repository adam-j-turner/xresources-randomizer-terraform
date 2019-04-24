resource "aws_ecs_cluster" "main" {
  name = "${var.region}-${var.app_name_short}-${var.environment}-ecs-cluster"
}

# data "template_file" "task_definition" {
#   template = "${file("${path.module}/task-definition.json")}"

#   vars {
#     container_name     = "${var.app_name_long}"
#     host_port          = "${var.alb_target_port}"
#     container_port     = "${var.alb_target_port}"
#     container_memory   = "${var.container_memory}"
#     container_cpu      = "${var.container_cpu}"
#     execution_role_arn = "${var.execution_role_arn}"
#     log_group_region   = "${var.region}"
#     log_group_name     = "/ecs/${var.app_name_long}"
#   }
# }

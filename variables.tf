variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "region" {default = "us-east-1"}

variable "environment" {}

variable "vpc_cidr_block" {default = "10.0.0.0/16"}

variable "subnet_count" {default = 2}

variable "app_name_long"  {default = "xresources-randomizer"}
variable "app_name_short" {default = "xrr"}

variable "alb_listen_port" {default=80}
variable "alb_target_port" {default=5000}

variable "container_memory" {default=1024}
variable "container_cpu"    {default=512}

variable "execution_role_arn" {}

variable "tf_backend_bucket_name" {}
variable "tf_backend_bucket_region" { default = "sa-east-1" }

variable "compute_workspace" {}
data "terraform_remote_state" "compute" {
  environment = "${var.compute_workspace}"
  backend = "s3"
  config {
    bucket = "${var.tf_backend_bucket_name}"
    key    = "state/compute/terraform.tfstate"
    region = "${var.tf_backend_bucket_region}"
  }
}

variable "dns_workspace" {}
data "terraform_remote_state" "dns" {
  environment = "${var.dns_workspace}"
  backend = "s3"
  config {
    bucket = "${var.tf_backend_bucket_name}"
    key    = "state/dns/terraform.tfstate"
    region = "${var.tf_backend_bucket_region}"
  }
}

variable "region" { default = "us-east-1" }
provider "aws" {
  region = "${var.region}"
}

data "aws_region" "current" {
  current = true
}

resource "aws_alb" "default" {
  name            = "gocd-server-${terraform.workspace}"
  tags { env = "${terraform.workspace}" }
  internal        = true
  subnets = ["${data.terraform_remote_state.compute.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.compute.ecs_services_security_group}"]
}

resource "aws_cloudwatch_log_group" "default" {
  name = "${terraform.workspace}"

  tags {
    Environment = "${terraform.workspace}"
  }
}

resource "aws_ecs_task_definition" "gocd-server" {
  family = "gocd-server"
  container_definitions = <<DEFINITIONS
[
  {
    "name": "gocd-server",
    "image": "akshaykarle/gocd-server:latest",
    "cpu": 2,
    "memory": 2048,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8153,
        "hostPort": 8153
      },
      {
        "containerPort": 8154,
        "hostPort": 8154
      }
    ],
    "mountPoints": [
      {
        "sourceVolume": "godata",
        "containerPath": "/godata"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.default.name}",
        "awslogs-region": "${data.aws_region.current.name}",
        "awslogs-stream-prefix": "gocd-server"
      }
    }
  }
]
DEFINITIONS

  volume {
    name = "godata"
    host_path = "/opt/gocd-server/data/"
  }
}

module "gocd-server" {
  source = "github.com/akshaykarle/terraform-ecs-modules/service_with_alb_listener"

  name = "gocd-server"
  ports = [8153, 8154]
  health_check_path = "/go/about"
  vpc_id = "${data.terraform_remote_state.compute.vpc_id}"
  cluster_id = "${data.terraform_remote_state.compute.ecs_cluster_name}"
  alb_arn = "${aws_alb.default.arn}"
  alb_dns_name = "${aws_alb.default.dns_name}"
  alb_zone_id = "${aws_alb.default.zone_id}"
  iam_role_arn = "${data.terraform_remote_state.compute.ecs_services_iam_role_arn}"
  route53_name = "${data.terraform_remote_state.dns.name}"
  route53_zone_id = "${data.terraform_remote_state.dns.zone_id}"
  task_definition = "${aws_ecs_task_definition.gocd-server.arn}"
}

data "aws_region" "current" {}

resource "aws_ecs_service" "service" {
  name            = var.name
  cluster         = var.cluster
  task_definition = aws_ecs_task_definition.task_def.arn
  desired_count   = var.container_count

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  capacity_provider_strategy {
    base              = 1
    capacity_provider = var.capacity_provider
    weight            = 100
  }

  dynamic "load_balancer" {
    for_each = var.enable_lb ? [1] : []
    content {
      target_group_arn = var.alb_target_group
      container_name   = var.name
      container_port   = var.service_port
    }
  }
}

resource "aws_ecs_task_definition" "task_def" {
  family                   = var.name
  execution_role_arn       = var.task_role
  requires_compatibilities = []
  tags                     = {}

  container_definitions = jsonencode([
    {
      name         = var.name
      image        = "public.ecr.aws/${var.ecr_registry}/${var.ecr_repository}:${var.deployed_version}"
      essential    = true
      cpu          = var.container_cpu
      memory       = var.container_mem
      network_mode = "awsvpc"
      mountPoints  = []
      volumesFrom  = []
      portMappings = var.enable_lb ? [
        {
          containerPort = var.service_port
          hostPort      = var.service_port
          protocol      = "tcp"
        }
      ] : []
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region = data.aws_region.current.name
          awslogs-group  = aws_cloudwatch_log_group.log_group.name
        }
      }
      environment = var.environment_variables
      secrets     = var.secrets
    }
  ])
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = var.name
  retention_in_days = 7
}

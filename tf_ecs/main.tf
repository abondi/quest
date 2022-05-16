resource "aws_ecs_cluster" "quest" {
  name = "quest"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_ecs_task_definition" "service" {
  family = "quest"
  cpu = 1024
  memory = 1024
  container_definitions = jsonencode([
    {
      name      = "quest"
      cpu       = 0
      essential = true
      image     = "340102753460.dkr.ecr.us-east-2.amazonaws.com/quest:latest"
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
  requires_compatibilities = ["EC2"]
}

resource "aws_ecs_service" "quest" {
  name            = "quest"
  cluster         = aws_ecs_cluster.quest.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.quest.arn
    container_name   = "quest"
    container_port   = 3000
  }

}

resource "aws_lb" "quest" {
  name               = "quest"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-03b7508e9863d88e0","sg-076e96d4954aadfe6"]
  subnets            = ["subnet-0a1966b0921639f18","subnet-0c05f2b3e383e647b"]
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "quest" {
  name     = "quest"
  port     = 3000
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = "vpc-0e58c3030cb3a9a43"
}

resource "aws_lb_listener" "quest" {
  load_balancer_arn = aws_lb.quest.arn
  port              = "3000"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-2:340102753460:certificate/3c079639-9b47-40b1-a7ee-d6a4e13adada"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.quest.arn
  }
}

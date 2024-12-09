# Create ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "my-ecs-cluster"
  tags = {
    Name = "ECS Cluster"
  }
}

# Create IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the ECS Task Execution Role policy
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "actions-generator-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn # <-- Ensure this is correct
  task_role_arn       = aws_iam_role.ecs_task_execution_role.arn # <-- Ensure this is correct

  container_definitions = jsonencode([
    {
      "name" : "actions-generator",
      "image" : "zinx666/actions_generator:2bb6fa8",
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : 5000,
        }
      ]
    }
  ])
}

# Create ECS Service
resource "aws_ecs_service" "ecs_service" {
  name            = "actions-generator-service-2"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task.id
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.public_sub1.id, aws_subnet.public_sub2.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
    container_name   = "actions-generator"
    container_port   = 5000
  }

  depends_on = [aws_lb.app_lb]
}

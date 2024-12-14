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
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      "name" : "actions-generator",
      "image" : "zinx666/actions_generator:a92df7b",
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : 5000, # internal port your service listens on
          "hostPort" : 5000,
          "protocol" : "tcp"
        },
        {
          "containerPort" : 80, # exposing port 80 externally
          "hostPort" : 80,      # external port (mapped to the Load Balancer)
          "protocol" : "tcp"
        },
        {
          "containerPort" : 443, # exposing port 443 externally
          "hostPort" : 443,      # external port (mapped to the Load Balancer)
          "protocol" : "tcp"
        }
      ]
    }
  ])
}

# Create ECS Service
resource "aws_ecs_service" "ecs_service" {
  name            = "actions-generator-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task.id
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.private_sub1.id, aws_subnet.private_sub2.id] # ECS tasks in private subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false # Fargate tasks in private subnets should not have public IP
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
    container_name   = "actions-generator"
    container_port   = 5000
  }

  depends_on = [aws_lb.app_lb] # Ensure LB is created before ECS service
}

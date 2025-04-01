resource "aws_security_group" "ecs_sg" {
    name = "fargate-sg"
    description = "Security Group for Fargate"
    vpc_id = aws_vpc.main_vpc.id
    #Defining the inbound rule
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.alb_sg.id]
    }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_ecs_cluster" "ecs_cluster" {
    name = "main-cluster"
   
  tags = {
    Name = "ECS Cluster"
  }
}
resource "aws_ecs_task_definition" "app_task" {
  family = "my-app-task"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn = aws_iam_role.ecs_task_role.arn
  cpu = "250"
  memory = "500"
  container_definitions = jsonencode([
{
    name = "my-app-container"
    image = "nginx:latest"
    cpu = 250
    memory = 500
    essential = true
    portMappings = [
        {
        containerPort = 80
        hostPort = 80
        protocol = "tcp"
        }
        
    ]
}
])
}
resource "aws_ecs_service" "fargate_service" {
    name = "fargate-service"
    cluster = aws_ecs_cluster.ecs_cluster.id
    task_definition = aws_ecs_task_definition.app_task.arn
    desired_count = 1
    launch_type = "FARGATE"
    network_configuration {
      subnets = [
        aws_subnet.private_subnet[0].id,  # reference private subnet ID directly
        aws_subnet.private_subnet[1].id   # reference private subnet ID directly
      ]
      security_groups = [aws_security_group.ecs_sg.id]
      assign_public_ip = false
    }
  
}
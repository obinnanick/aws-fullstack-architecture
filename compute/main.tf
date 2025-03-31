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
  execution_role_arn = aws_iam_role.ec2_task_execution_role.arn
  task_role_arn = aws_iam_role.ecs_task_role.arn
}
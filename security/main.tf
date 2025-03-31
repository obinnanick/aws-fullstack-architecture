resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Effect = "Allow"
        Principal = {
            Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
    }]
  })
  tags = {
    Name = "ECS task role"
  }
}
resource "aws_iam_policy_attachment" "ec2_task_execution_policy" {
    name = "ec2-task-attachment-execution-policy"
  roles = [aws_iam_role.ecs_task_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

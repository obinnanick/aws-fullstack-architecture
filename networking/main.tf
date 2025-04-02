resource "aws_lb" "ecs_alb" {
  name = "ecs-lb"
  subnets = [aws_subnet.public_subnets[0].id, aws_subnet.public_subnets[1].id]
  load_balancer_type = "application"
  internal = false
}
resource "aws_lb_target_group" "ecs_target" {
  name = "ecs-target-group"
  vpc_id = aws_vpc.main_vpc.id
  target_type = "ip"
  health_check {
    
    path = "/"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}
resource "aws_lb_listener" "ecs_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.ecs_target.arn
    type = "forward"
  }
}
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity = 5
  min_capacity = 1
  resource_id = "service /${aws_cluster.ecs_cluster.name}/${aws_ecs_service.fargate_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}
resource "aws_appautoscaling_policy" "ecs_scaling" {
name = "ECS scaling"
scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
service_namespace = aws_appautoscaling_target.ecs_target.service_namespace
resource_id = aws_appautoscaling_target.ecs_target.resource_id

target_tracking_scaling_policy_configuration {
  target_value = 50
  predefined_metric_specification {
    predefined_metric_type = "ECSServiceAverageCPUUtilization"
  }
}
}
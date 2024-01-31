#################################################
# NLB
#################################################
resource "aws_lb" "nlb" {
  name = "test-nlb"
  internal = false
  load_balancer_type = "network"
  subnets = var.nlb_subnets
  enable_cross_zone_load_balancing = false
}

# nlb target group
resource "aws_lb_target_group" "nlb_target_group" {
  name = "test-nlb-target-group"
  port = 80
  protocol = "TCP"
  vpc_id = var.vpc_id
  target_type = "alb"

  health_check {
    protocol = "HTTP"
    matcher = "200-299"
  }
}

resource "aws_lb_target_group_attachment" "nlb_target_group_attachment" {
  target_group_arn = aws_lb_target_group.nlb_target_group.arn
  target_id = aws_lb.alb.arn
}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port = 80
  protocol = "TCP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.nlb_target_group.arn
  }
}

#################################################
# ALB
#################################################
resource "aws_lb" "alb" {
  name = "test-alb"
  internal = true
  load_balancer_type = "application"
  security_groups = var.alb_security_groups
  subnets = var.alb_subnets
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_target_group" "alb_target_group" {
  name = "test-alb-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  load_balancing_algorithm_type = "least_outstanding_requests"

  health_check {
    protocol = "HTTP"
    matcher = "200-299"
  }
}

resource "aws_lb_target_group_attachment" "alb_target_group_attachment" {
  count = length(var.alb_target_ec2_list)
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id = var.alb_target_ec2_list[count.index]
  port = 8080
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

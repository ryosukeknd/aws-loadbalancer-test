#################################################
# NLB
#################################################
resource "aws_lb" "nlb" {
  name = "test-nlb"
  internal = false
  load_balancer_type = "network"
  subnets = var.nlb_subnets
}

# nlb target group
resource "aws_lb_target_group" "nlb_target_group" {
  name = "test-nlb-target-group"
  port = 80
  protocol = "TCP"
  vpc_id = var.vpc_id

  health_check {
    protocol = "HTTP"
    matcher = "200-299"
  }
}

resource "aws_lb_target_group_attachment" "nlb_target_group_attachment" {
  count = length(var.nlb_target_ec2_list)
  target_group_arn = aws_lb_target_group.nlb_target_group.arn
  target_id = var.nlb_target_ec2_list[count.index]
  port = 8080
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

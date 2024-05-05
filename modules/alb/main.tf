resource "aws_lb" "alb" {
  name               = "${var.env}-${var.system}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = tolist(var.subnets)

  enable_deletion_protection       = false
  enable_http2                     = true
  enable_cross_zone_load_balancing = true
  idle_timeout                     = 60

  //access_logs {
  //    bucket = "${var.env}-${var.system}-alb-logs"
  //    prefix = "alb"
  //    enabled = true
  //}

  tags = {
    Name = "${var.env}-${var.system}-alb"
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "${var.env}-${var.system}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.env}-${var.system}-tg"
  }
}

resource "aws_lb_listener" "listener443" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  certificate_arn = var.cert_arn
}

resource "aws_lb_listener" "listener80" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
    redirect {
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_target_group_attachment" "tg_attachment" {
  count            = length(var.instance_ids)
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = element(var.instance_ids, count.index)
  port             = 80
}

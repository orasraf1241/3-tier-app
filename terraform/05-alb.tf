############################################## External ALB #############################

resource "aws_lb_target_group" "target_group_fronted" {
  name        = "${var.frontend_name}-tg"
  port        = var.port_frontend
  protocol    = var.protocol_http
  target_type = var.target_type
  vpc_id      = module.vpc.vpc_id

  health_check {
    enabled             = true
    interval            = 10
    path                = "/"
    port                = var.port_frontend
    protocol            = var.protocol_http
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

}

# creating ALB
resource "aws_lb" "application-lb_frontend" {
  name               = "${var.frontend_name}-alb"
  internal           = var.load_balancer_internal
  load_balancer_type = var.load_balancer_type
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.backend-server.id, aws_security_group.lb_sg.id]

  ip_address_type = var.ip_address_type
  depends_on      = [module.frontend_asg]

}

resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.application-lb_frontend.arn
  port              = var.port_http
  protocol          = var.protocol_http

  default_action {
    type             = var.aws_lb_listener_type
    target_group_arn = aws_lb_target_group.target_group_fronted.arn
  }
}





######################## Interan ALB  for backend ###################################


resource "aws_lb_target_group" "target_group_backend" {
  name        = "${var.backend_name}-tg"
  port        = var.port_backend
  protocol    = var.protocol_http
  target_type = var.target_type
  vpc_id      = module.vpc.vpc_id

  health_check {
    enabled             = true
    interval            = 10
    path                = "/"
    port                = var.port_backend
    protocol            = var.protocol_http
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

}

# creating ALB
resource "aws_lb" "application_lb_backend" {
  name               = "${var.backend_name}-alb"
  internal           = true
  load_balancer_type = var.load_balancer_type
  subnets            = module.vpc.private_subnets
  security_groups    = [aws_security_group.backend-server.id, aws_security_group.lb_sg.id]

  ip_address_type = var.ip_address_type
  depends_on      = [module.backend_asg]

}

resource "aws_lb_listener" "alb_listener_backend" {
  load_balancer_arn = aws_lb.application_lb_backend.arn
  port              = var.port_http
  protocol          = var.protocol_http

  default_action {
    type             = var.aws_lb_listener_type
    target_group_arn = aws_lb_target_group.target_group_backend.arn
  }
}

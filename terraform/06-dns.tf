
resource "aws_route53_zone" "private" {
  name = "terasky-int.com"

  vpc {
    vpc_id = module.vpc.vpc_id
  }
}

resource "aws_route53_record" "backend" {
  zone_id = aws_route53_zone.private.zone_id
  name    = var.backend_name
  type    = "A"

  alias {
    name                   = aws_lb.application_lb_backend.dns_name
    zone_id                = aws_lb.application_lb_backend.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "frontend" {
  zone_id = aws_route53_zone.private.zone_id
  name    = var.frontend_name
  type    = "A"

  alias {
    name                   = aws_lb.application-lb_frontend.dns_name
    zone_id                = aws_lb.application-lb_frontend.zone_id
    evaluate_target_health = true
  }
}


resource "aws_route53_record" "database" {
  zone_id = aws_route53_zone.private.zone_id
  name    = var.db_name
  type    = "CNAME"
  ttl     = "300"
  records = [aws_db_instance.mysql-rds.address]
}
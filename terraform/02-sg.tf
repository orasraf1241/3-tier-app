
resource "aws_security_group" "rds_sg" {
  name   = "${var.db_name}-db-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = var.port_database
    to_port     = var.port_database
    protocol    = var.protocol_tcp
    cidr_blocks = var.private_subnets
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = var.sg_cidr
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "backend-server" {
  name   = "${var.backend_name}-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = var.port_frontend
    to_port     = var.port_frontend
    protocol    = var.protocol_tcp
    cidr_blocks = var.private_subnets
  }
  ingress {
    from_port   = var.port_frontend
    to_port     = var.port_frontend
    protocol    = var.protocol_tcp
    cidr_blocks = var.public_subnets
  }

  ingress {
    from_port   = var.port_backend
    to_port     = var.port_backend
    protocol    = var.protocol_tcp
    cidr_blocks = var.private_subnets
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.sg_cidr
  }
}

resource "aws_security_group" "lb_sg" {
  name        = "alb-sg"
  description = "lb sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = var.port_http
    to_port     = var.port_http
    protocol    = var.protocol_tcp
    cidr_blocks = var.sg_cidr
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = var.sg_cidr
    ipv6_cidr_blocks = ["::/0"]
  }
}



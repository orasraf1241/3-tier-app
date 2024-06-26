
############################# Frontend Auto Scaling Group ##########################

module "frontend_asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name = var.frontend_asg_name

  min_size                  = var.frontend_asg_min_szie
  max_size                  = var.frontend_asg_max_size
  desired_capacity          = var.frontend_asg_desired_capacity
  wait_for_capacity_timeout = var.frontend_asg_wait_for_capacity_timeout
  health_check_type         = "EC2"
  vpc_zone_identifier       = module.vpc.private_subnets


  # Launch template
  launch_template_name        = var.frontend_asg_name
  launch_template_description = "Launch template for frontend machine "
  update_default_version      = true


  image_id          = var.frontend_ami
  instance_type     = var.frontend_instance_type
  ebs_optimized     = true
  enable_monitoring = true

  # IAM role & instance profile
  create_iam_instance_profile = true
  iam_role_name               = "session-manger"
  iam_role_path               = "/ec2/"
  iam_role_description        = "IAM role example"
  iam_role_tags = {
    CustomIamRole = "Yes"
  }
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }


  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 20
        volume_type           = "gp2"
      }
      }, {
      device_name = "/dev/sda1"
      no_device   = 1
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 30
        volume_type           = "gp2"
      }
    }
  ]

  capacity_reservation_specification = {
    capacity_reservation_preference = "open"
  }

  cpu_options = {
    core_count       = 1
    threads_per_core = 1
  }

  credit_specification = {
    cpu_credits = "standard"
  }


  # This will ensure imdsv2 is enabled, required, and a single hop which is aws security
  # best practices
  # See https://docs.aws.amazon.com/securityhub/latest/userguide/autoscaling-controls.html#autoscaling-4
  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  network_interfaces = [
    {
      delete_on_termination = true
      description           = "eth0"
      device_index          = 0
      security_groups       = [aws_security_group.lb_sg.id, aws_security_group.rds_sg.id, aws_security_group.backend-server.id]
    }
  ]

  placement = {
    availability_zone = "eu-ewst-2b"
  }

}

resource "aws_autoscaling_attachment" "asg_to_alb_frontend" {
  autoscaling_group_name = module.frontend_asg.autoscaling_group_id
  lb_target_group_arn    = aws_lb_target_group.target_group_fronted.id
}

############################# Backend Auto Scaling Group ##########################
#
#
#####################################################################################

module "backend_asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name = var.backend_name

  min_size                  = var.backend_asg_min_szie
  max_size                  = var.backend_asg_max_size
  desired_capacity          = var.backend_asg_desired_capacity
  wait_for_capacity_timeout = var.backend_asg_wait_for_capacity_timeout
  health_check_type         = "EC2"
  vpc_zone_identifier       = module.vpc.private_subnets

  # Launch template
  launch_template_name        = "${var.backend_name}-lt"
  launch_template_description = "Launch template for frontend machine "
  update_default_version      = true

  image_id          = var.backend_ami
  instance_type     = var.backend_instance_type
  ebs_optimized     = true
  enable_monitoring = true


  # IAM role & instance profile
  create_iam_instance_profile = true
  iam_role_name               = "session-mannager"
  iam_role_path               = "/ec2/"
  iam_role_description        = "IAM role example"
  iam_role_tags = {
    CustomIamRole = "Yes"
  }
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 20
        volume_type           = "gp2"
      }
      }, {
      device_name = "/dev/sda1"
      no_device   = 1
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 30
        volume_type           = "gp2"
      }
    }
  ]


  network_interfaces = [
    {
      delete_on_termination = true
      description           = "eth0"
      device_index          = 0
      security_groups       = [aws_security_group.lb_sg.id, aws_security_group.backend-server.id, aws_security_group.rds_sg.id]
    }
  ]
}


resource "aws_autoscaling_attachment" "asg_to_alb_backend" {
  autoscaling_group_name = module.backend_asg.autoscaling_group_id
  lb_target_group_arn    = aws_lb_target_group.target_group_backend.id
}

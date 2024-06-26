# AWS Region
variable "region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "eu-west-2"
}

variable "frontend_name" {
  description = "The name fo the frontend env for DNS "
  type        = string
  default     = "frontend"
}


variable "backend_name" {
  description = "name fo the backend"
  type        = string
  default     = "backend"
}



################################################### VPC #######################################################
variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = "vpc-asraf"
}

# VPC CIDR Block
variable "cidr" {
  description = "VPC CIDR Block"
  type        = string
  default     = "10.0.0.0/16"
}

# VPC Availability Zones
variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b"]
}

# VPC Public Subnets
variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

# VPC Private Subnets
variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# VPC Database Subnets
variable "database_subnets" {
  description = "A list of database subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.151.0/24", "10.0.152.0/24"]
}

# VPC Create Database Subnet Group (True / False)
variable "create_database_subnet_group" {
  description = "VPC Create Database Subnet Group, Controls if database subnet group should be created"
  type        = bool
  default     = true
}

# VPC Create Database Subnet Route Table (True or False)
variable "create_database_subnet_route_table" {
  description = "VPC Create Database Subnet Route Table, Controls if separate route table for database should be created"
  type        = bool
  default     = true
}


# VPC Enable NAT Gateway (True or False) 
variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = true
}

# VPC Single NAT Gateway (True or False)
variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = true
}

############################################# security group #######################################################



variable "port_frontend" {
  description = "port number of the frontend app"
  type        = number
  default     = 3000
}

variable "port_backend" {
  description = "port number of the backend app"
  type        = number
  default     = 5000
}

variable "port_database" {
  description = "port number of the database app"
  type        = number
  default     = 3306
}

variable "port_http" {
  description = "port number of the database app"
  type        = number
  default     = 80
}

variable "protocol_http" {
  description = "http protocol for sg and helthchecks"
  type        = string
  default     = "HTTP"
}

variable "protocol_tcp" {
  description = "tcp protocol name for sg and helthchecks"
  type        = string
  default     = "tcp"
}

variable "sg_cidr" {
  description = "all to ip range"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}


############################################# RDS ####################################################
# Rds Password 
variable "db_pass" {
  description = "password of the database live it empty and enter when you create "
  type        = string

}

variable "db_name" {
  description = "database name"
  type        = string
  default     = "backend"

}
variable "db_user" {
  description = "user name for the data base "
  type        = string
  default     = "root"
}

variable "db_instance_type" {
  description = "the db instance type "
  type        = string
  default     = "db.t3.micro"
}

variable "db_engine" {
  description = "type of the db engine for example mysql or postgress etc..."
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "version of the db engine"
  type        = string
  default     = "5.7"
}

################### Auto scaling group ######################################

# frontend vars
variable "frontend_asg_name" {
  type    = string
  default = "frontend-asg"
}

variable "frontend_ami" {
  type    = string
  default = "ami-0e6c17d28dc6c4208"
}

variable "frontend_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "frontend_asg_min_szie" {
  type    = number
  default = 2
}

variable "frontend_asg_max_size" {
  type    = number
  default = 4
}

variable "frontend_asg_desired_capacity" {
  type    = number
  default = 2
}

variable "frontend_asg_wait_for_capacity_timeout" {
  type    = number
  default = 0
}

# backend vars

variable "backend_asg" {
  type    = string
  default = "backend-asg"
}

variable "backend_ami" {
  type    = string
  default = "ami-04e1ec573bbbafba8"
}

variable "backend_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "backend_asg_min_szie" {
  type    = number
  default = 2
}

variable "backend_asg_max_size" {
  type    = number
  default = 4
}

variable "backend_asg_desired_capacity" {
  type    = number
  default = 2
}

variable "backend_asg_wait_for_capacity_timeout" {
  type    = number
  default = 0
}

##################################### Load Balancer ############################################
variable "load_balancer_type" {
  description = "the ttype of LB application, nework etc..."
  type        = string
  default     = "application"
}

variable "load_balancer_internal" {
  description = "the ttype of LB application, nework etc..."
  type        = bool
  default     = false
}

variable "target_type" {
  description = "The type for target group"
  type        = string
  default     = "instance"
}

variable "aws_lb_listener_type" {
  description = "the type of the aws_lb_listener "
  type        = string
  default     = "forward"
}

variable "ip_address_type" {
  description = "the type of the ip address ipv4 or ipv6 "
  type        = string
  default     = "ipv4"
}



############################################### Tags #####################################
variable "tags" {
  type = map(string)
  default = {
    "Created By" = "orasraf@terasky.com"
    "Purpose"    = "learning"
    "terraform"  = "true"
    "Env"        = "stage"
  }
}
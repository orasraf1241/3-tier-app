resource "aws_db_instance" "mysql-rds" {
  allocated_storage       = 5
  identifier              = var.db_name
  db_name                 = var.db_name
  engine                  = var.db_engine
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_type
  username                = var.db_user
  password                = var.db_pass
  skip_final_snapshot     = true
  backup_retention_period = 7
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name

}



resource "aws_db_instance" "replica-mysql-rds" {
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_type
  skip_final_snapshot     = true
  backup_retention_period = 7
  replicate_source_db     = aws_db_instance.mysql-rds.identifier
}


resource "aws_db_subnet_group" "db_subnet_group" {
  name = "main"

  subnet_ids = [
    module.vpc.database_subnets[0],
    module.vpc.database_subnets[1]
  ]
}

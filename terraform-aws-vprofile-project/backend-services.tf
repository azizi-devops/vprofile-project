resource "aws_db_subnet_group" "vprofile_db_subnet_group" {
  name       = "vprofile-db-subnet-group"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]

  tags = {
    Name = "Subnet Group for RDS"
  }
}


resource "aws_db_instance" "vprofile_db_instance" {
  identifier             = "vprofile-db-instance"
  allocated_storage      = 20
  storage_type           = "gp3"
  db_name                = var.dbname
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = var.dbuser
  password               = var.dbpass
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  multi_az               = false
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.vprofile_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.vprofile-backend-sg.id]

}

########################################################################################################

resource "aws_elasticache_subnet_group" "vprofile_cache_subnet_group" {
  name       = "vprofile-cache-subnet-group"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]

  tags = {
    Name = "Subnet Group for ElastiCache"
  }
}

resource "aws_elasticache_cluster" "vprofile_cache" {
  cluster_id           = "vprofile-cache"
  engine               = "memcached"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.memcached1.6"
  port                 = 11211
  subnet_group_name    = aws_elasticache_subnet_group.vprofile_cache_subnet_group.name
  security_group_ids   = [aws_security_group.vprofile-backend-sg.id]

}

#########################################################################################################

resource "aws_mq_broker" "vprofile_rabbitmq_broker" {

  broker_name                = "vprofile-rabbitmq-broker"
  engine_type                = "RabbitMQ"
  engine_version             = "3.13"
  host_instance_type         = "mq.t3.micro"
  security_groups            = [aws_security_group.vprofile-backend-sg.id]
  auto_minor_version_upgrade = true
  subnet_ids                 = [module.vpc.private_subnets[0]]
  user {
    username = var.rmquser
    password = var.rmqpass
  }
}
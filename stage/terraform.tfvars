system = "test"
env    = "prd"

cidr_vpc = "10.1.0.0/16"

cidr_public = [
  "10.1.1.0/24",
  "10.1.2.0/24",
  "10.1.3.0/24"
]

cidr_private = [
  "10.1.101.0/24",
  "10.1.102.0/24",
  "10.1.103.0/24"
]

instance_count = 1

instance_type = "t2.micro"

ami = "ami-0c1de55b79f5aff9b"

disable_api_termination = false

name = "mamorukun"

rds_allocated_storage       = 20
rds_storage_type            = "gp2"
rds_engine                  = "mysql"
rds_engine_version          = "5.7"
rds_instance_class          = "db.t3.medium"
rds_db_name                 = "mydatabase"
rds_username                = "adminuser"
rds_password                = "verysecretpassword"
rds_multi_az                = true
rds_storage_encrypted       = true
rds_skip_final_snapshot     = true
rds_backup_retention_period = 7
rds_backup_window           = "03:00-04:00"
rds_maintenance_window      = "sun:04:00-sun:05:00"
rds_parameter_family        = "mysql5.7"
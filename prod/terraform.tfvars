system = "production"
env    = "prd"

cidr_vpc = "10.2.0.0/16"

cidr_public = [
  "10.2.1.0/24",
  "10.2.2.0/24",
  "10.2.3.0/24"
]

cidr_private = [
  "10.2.101.0/24",
  "10.2.102.0/24",
  "10.2.103.0/24"
]

domain_name = "example.com"

ec2_instance_count = 3

ec2_instance_type = "t2.medium"

ec2_ami = "ami-0c1de55b79f5aff9b"

ec2_disable_api_termination = true

name = "production-example"

rds_engine                  = "aurora-mysql"
rds_engine_version          = "5.7"
rds_instance_class          = "db.r5.large"
rds_db_name                 = "mydatabase"
rds_username                = "adminuser"
rds_password                = "extremelysecretpassword"
rds_storage_encrypted       = true
rds_skip_final_snapshot     = false
rds_backup_retention_period = 14
rds_backup_window           = "03:00-05:00"
rds_maintenance_window      = "sun:05:00-sun:07:00"
rds_parameter_family        = "aurora-mysql5.7"
rds_instance_count          = 2

s3_bucket_name = "prod-example"

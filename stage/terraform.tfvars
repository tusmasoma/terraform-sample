system   = "test"
env      = "prd"

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

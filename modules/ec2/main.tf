resource "aws_instance" "ec2" {
    count = var.instance_count
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_ids = element(tolist(var.subnets), count.index % length(var.subnets))
    security_group_ids = var.security_group_ids
    disable_api_termination = var.disable_api_termination

    tags = {
        Name = "${var.system}-${var.env}-ec2-${count.index + 1}"
    }

    lifecycle {
        create_before_destroy = true
    }
}
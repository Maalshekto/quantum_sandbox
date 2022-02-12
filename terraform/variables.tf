variable "instance_type" {
    type = string
    description = "set aws instance type"
    default = "t2.micro"
}

variable "aws_common_tag" {
    type = map
    description = "Set aws tag"
    default = {
        Name = "ec2-thomas"
    }
  
}
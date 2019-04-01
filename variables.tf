variable "name" {
  description = "Project information, used for tags and unique iam role name"
  default     = "Example-Spot-Fleet"
}

variable "subnet_id" {
  description = "Placement subnet ID"
}

data "aws_subnet" "default" {
  id = "${var.subnet_id}"
}

locals {
  az = "${data.aws_subnet.default.availability_zone}"
}

variable "ssh_key" {
  description = "SSH pair name to link with fleet nodes"
}

variable "security_group_ids" {
  description = "Placement security group"
  type        = "list"
}

locals {
  security_groups = ["${
    compact(distinct(concat(
        var.security_group_ids,
        list("${var.internet_access ? aws_security_group.access_to_internet.id : ""}")
    )))
  }"]
}

variable "iam_instance_profile_arn" {
  description = "IAM instance profile arn (required for ECS node)"
  default     = ""
}

variable "capacity" {
  description = "Desired amount of nodes"
  default     = 1
}

variable "type" {
  description = "Type of launch configuration (supported values are 'common_node' and 'ecs_node')"
  default     = "common_node"
}

variable "common_node_ami_id" {
  description = "AMI image used for common_node type of launch configuration (default is the most recent Amazon provided AMI)"
  default     = ""
}

variable "ecs_node_ami_id" {
  description = "AMI image used for ecs_node type of launch configuration (default is the most recent Amazon provided AMI)"
  default     = ""
}

variable "ec2_type" {
  description = "AWS EC2 type"
  default     = "t2.small"
}

variable "userdata" {
  description = "Userdata script body"
  default     = ""
}

variable "disk_size_root" {
  description = "Size of instance root partition (GB)"
  default     = 8
}

variable "disk_size_docker" {
  description = "Size of instance docker partition, used for ecs_node type (GB)"
  default     = 25
}

variable "valid_until" {
  description = "The date until spot request is valid"
  default     = "2033-01-01T01:00:00Z"
}

variable "public_ip" {
  description = "Assign public IP on EC2 node"
  default     = false
}

variable "internet_access" {
  description = "Allow access to internet"
  default     = true
}

variable "lb_integration" {
  description = "Switch to enable/disable LB integration. If True - load_balancers and target_group_arns should be defined"
  default     = "false"
}

variable "load_balancers" {
  description = "A list of elastic load balancer names to add to the Spot fleet"
  default     = [""]
}

variable "target_group_arns" {
  description = "A list of aws_alb_target_group ARNs, for use with Application Load Balancing"
  default     = [""]
}

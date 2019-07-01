## About

Terraform module to create AWS Spot instances for various purposes. 

The module provide the following profiles:

* ECS node
* Common node

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| capacity | Desired amount of nodes | string | `"1"` | no |
| common\_node\_ami\_id | AMI image used for common_node type of launch configuration (default is the most recent Amazon provided AMI) | string | `""` | no |
| disk\_size\_docker | Size of instance docker partition, used for ecs_node type (GB) | string | `"25"` | no |
| disk\_size\_root | Size of instance root partition (GB) | string | `"8"` | no |
| ec2\_type | AWS EC2 type | string | `"t2.small"` | no |
| ecs\_node\_ami\_id | AMI image used for ecs_node type of launch configuration (default is the most recent Amazon provided AMI) | string | `""` | no |
| iam\_instance\_profile\_arn | IAM instance profile arn (required for ECS node) | string | `""` | no |
| internet\_access | Allow access to internet | string | `"true"` | no |
| lb\_integration | Switch to enable/disable LB integration. If True - load_balancers and target_group_arns should be defined | string | `"false"` | no |
| load\_balancers | A list of elastic load balancer names to add to the Spot fleet | list | `<list>` | no |
| name | Project information, used for tags and unique iam role name | string | `"Example-Spot-Fleet"` | no |
| public\_ip | Assign public IP on EC2 node | string | `"false"` | no |
| security\_group\_ids | Placement security group | list | n/a | yes |
| ssh\_key | SSH pair name to link with fleet nodes | string | n/a | yes |
| subnet\_id | Placement subnet ID | string | n/a | yes |
| target\_group\_arns | A list of aws_alb_target_group ARNs, for use with Application Load Balancing | list | `<list>` | no |
| type | Type of launch configuration (supported values are 'common_node' and 'ecs_node') | string | `"common_node"` | no |
| userdata | Userdata script body | string | `""` | no |
| valid\_until | The date until spot request is valid | string | `"2033-01-01T01:00:00Z"` | no |
| termination\_on\_expiration_policy | Actions after spot request expires | boolean | `"false"` | no

## Usage

Example: One linux box 
```
module "bastion_host" {
    source               = ""
    name                 = "Bastion host"
    subnet_id            = "${aws_subnet.default.id}"
    ssh_key              = "${aws_key_pair.default.id}"
    security_group_ids   = ["${aws_security_group.myecs.id}"]
}
```

Example: Five ECS nodes of __c5.large__ type
```
module "my_ecs_nodes" {
    source                   = "github.com/jetbrains-infra/terraform-aws-spot-fleet"
    name                     = "Example ECS cluster"
    subnet_id                = "${aws_subnet.default.id}"
    security_group_ids       = ["${aws_security_group.myecs.id}"]
    iam_instance_profile_arn = "${aws_iam_instance_profile.ecs_node.arn}" // wtf
    capacity                 = "5"
    type                     = "ecs_node" // currently supported values are "common_node" & "ecs_node"
    ec2_type                 = "c5.large"
    userdata                 = <<EOT
#!/bin/bash
echo ECS_CLUSTER="${aws_ecs_cluster.example.name}" >> /etc/ecs/ecs.config

EOT
}
```

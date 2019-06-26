resource "aws_spot_fleet_request" "common_nodes_no_lb" {
  count               = "${ var.lb_integration ? 0 : "${var.type == "common_node" ? 1 : 0}" }"
  iam_fleet_role      = "${aws_iam_role.spot-fleet-tagging-role.arn}"
  allocation_strategy = "diversified"
  target_capacity     = "${var.capacity}"
  valid_until         = "${var.valid_until}"
  terminate_instances_with_expiration = "${var.termination_on_expiration_policy}"

  launch_specification {
    instance_type               = "${var.ec2_type}"
    ami                         = "${var.common_node_ami_id == "" ? data.aws_ami.common_ami.id : var.common_node_ami_id}"
    key_name                    = "${var.ssh_key}"
    availability_zone           = "${local.az}"
    subnet_id                   = "${var.subnet_id}"
    vpc_security_group_ids      = ["${local.security_groups}"]
    associate_public_ip_address = "${var.public_ip}"

    // root partition
    root_block_device {
      volume_size           = "${var.disk_size_root}"
      volume_type           = "gp2"
      delete_on_termination = true
    }

    user_data = "${var.userdata}"

    tags {
      Name = "${var.name} node"
    }
  }
}

resource "aws_spot_fleet_request" "common_nodes_lb" {
  count               = "${ var.lb_integration ? "${var.type == "common_node" ? 1 : 0}" : 0 }"
  iam_fleet_role      = "${aws_iam_role.spot-fleet-tagging-role.arn}"
  allocation_strategy = "diversified"
  target_capacity     = "${var.capacity}"
  valid_until         = "${var.valid_until}"

  load_balancers    = ["${var.load_balancers}"]
  target_group_arns = ["${var.target_group_arns}"]

  launch_specification {
    instance_type               = "${var.ec2_type}"
    ami                         = "${var.common_node_ami_id == "" ? data.aws_ami.common_ami.id : var.common_node_ami_id}"
    key_name                    = "${var.ssh_key}"
    availability_zone           = "${local.az}"
    subnet_id                   = "${var.subnet_id}"
    vpc_security_group_ids      = ["${local.security_groups}"]
    associate_public_ip_address = "${var.public_ip}"

    // root partition
    root_block_device {
      volume_size           = "${var.disk_size_root}"
      volume_type           = "gp2"
      delete_on_termination = true
    }

    user_data = "${var.userdata}"

    tags {
      Name = "${var.name} node"
    }
  }
}

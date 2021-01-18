data "template_file" "node-pool-userdata" {
  template = "${file("${path.module}/userdata/node-pool.tpl")}"

  vars = {
    cluster_endpoint = aws_eks_cluster.eks-cluster.endpoint
    cluster_ca       = aws_eks_cluster.eks-cluster.certificate_authority.0.data
    cluster_name     = var.eks_cluster_name
  }
}

resource "aws_launch_configuration" "eks-launch-config" {
  associate_public_ip_address = false
  iam_instance_profile = aws_iam_instance_profile.node.name
  image_id = var.ami_id
  instance_type = var.eks_node_instance_type
  name_prefix = "eks"
  security_groups = [var.sg_eks_node_id,
    var.sg_admin_id,
  ]
  user_data = data.template_file.node-pool-userdata.rendered
  key_name = var.key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "eks-autoscaling" {
  name = "eks-worker-node-asg"
  desired_capacity = lookup(var.eks_autoscaling, "desired")
  launch_configuration = aws_launch_configuration.eks-launch-config.name
  max_size = lookup(var.eks_autoscaling, "max")
  min_size = lookup(var.eks_autoscaling, "min")
  vpc_zone_identifier = var.private_subnet_ids

  tag {
    key = "Name"
    value = "eks-worker-node-asg"
    propagate_at_launch = true
  }

  tag {
    key = "kubernetes.io/cluster/ipa-cn-${var.env}-eks-cluster"
    value = "owned"
    propagate_at_launch = true
  }
}

resource "aws_iam_role" "spinnaker-managed" {
  name               = "spinnaker-managed-role"
  assume_role_policy = data.aws_iam_policy_document.spinnaker-managed-trusted-policy.json
}

data "aws_iam_policy_document" "spinnaker-managed-trusted-policy" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "ecs.amazonaws.com",
        "ecs-tasks.amazonaws.com",
        "application-autoscaling.amazonaws.com",
        "ec2.amazonaws.com",
      ]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "s3-full-access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.spinnaker-managed.id
}
/*

resource "aws_iam_role_policy_attachment" "vpc-full-accs" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
  role       = aws_iam_role.spinnaker-managed.id
}

resource "aws_iam_role_policy_attachment" "ec2-full-accs" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.spinnaker-managed.id
}

resource "aws_iam_role_policy_attachment" "ecs-full-accs" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
  role       = aws_iam_role.spinnaker-managed.id
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.spinnaker-managed.id
}

resource "aws_iam_role_policy_attachment" "secret_manager" {
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  role       = aws_iam_role.spinnaker-managed.id
}

resource "aws_iam_role_policy_attachment" "lambda-full-accs" {
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaFullAccess"
  role       = aws_iam_role.spinnaker-managed.id
}

resource "aws_iam_role_policy_attachment" "ecr_read" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.spinnaker-managed.id
}

resource "aws_iam_role_policy_attachment" "cfn_read" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudFormationReadOnlyAccess"
  role       = aws_iam_role.spinnaker-managed.id
}

resource "aws_iam_role_policy_attachment" "iam_read" {
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
  role       = aws_iam_role.spinnaker-managed.id
}

*/

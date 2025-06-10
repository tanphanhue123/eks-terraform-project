module "iam_role_ec2_bastion" {
  source = "../../../modules/iam-role"
  #basic
  env     = var.env
  project = var.project

  #iam-role
  name    = "ec2-bastion"
  service = "ec2"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "ec2.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
  iam_default_policy_arn = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]
  iam_custom_policy = {
    template = jsonencode(
      {
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Effect" : "Allow",
            "Action" : [
              "ec2:DescribeInstances",
              "ec2:DescribeTags",
              "ec2:DescribeAddresses",
              "ec2:CreateTags"
            ],
            "Resource" : "*"
          }
        ]
      }
    )
  }
  iam_instance_profile = true
}

module "security_group_ec2_bastion" {
  source = "../../../modules/sg"
  #basic
  env     = var.env
  project = var.project

  #security_group
  name   = "ec2-bastion"
  vpc_id = module.vpc-eks.vpc_id
  ingress = [
    {
      description = "Allow SSH for all IPs"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = 22
      to_port     = 22
    }
  ]
}

#bastion
module "ec2_instance_bastion" {
  source = "../../../modules/ec2-instance"
  #basic
  env     = var.env
  project = var.project
  #ec2-instance
  name                 = "bastion"
  ami_id               = "ami-0db548937a54fa3a7" #AMI Ubuntu 20.04
  instance_type        = "t3a.micro"
  key_name             = "${var.project}-${var.env}-keypair"
  security_group_ids   = [module.security_group_ec2_bastion.sg_id]
  subnet_id            = module.vpc-eks.subnet_public_id[0]
  iam_instance_profile = module.iam_role_ec2_bastion.iam_instance_profile_id
  root_block_device = {
    volume_type = "gp3"
    volume_size = "20"
  }
  monitoring = true
  #eip
  ec2_instance_id = module.ec2_instance_bastion.ec2_instance_id
  type            = "bastion"
}

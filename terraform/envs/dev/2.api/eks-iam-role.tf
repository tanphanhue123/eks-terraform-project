### NODE GROUP
module "iam_role_node_group" {
  source = "../../../modules/iam-role"
  #basic
  env     = var.env
  project = var.project

  #iam-role
  name    = "node-group"
  service = "eks"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "sts:AssumeRole"
          ],
          "Principal" : {
            "Service" : [
              "ec2.amazonaws.com"
            ]
          }
        }
      ]
    }
  )
  iam_default_policy_arn = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
  iam_instance_profile = true
}

### EKS CLUSTER
module "iam_role_eks_cluster" {
  source = "../../../modules/iam-role"
  #basic
  env     = var.env
  project = var.project

  #iam-role
  name    = "eks-cluster"
  service = "eks"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "eks.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
  iam_default_policy_arn = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  ]
}

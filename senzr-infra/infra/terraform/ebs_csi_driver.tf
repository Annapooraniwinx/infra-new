module "ebs_csi_driver" {
  source  = "terraform-aws-modules/eks/aws//modules/ebs-csi-driver"
  version = "~> 19.0"

  cluster_name = module.eks.cluster_name

  create_irsa = true
  irsa_iam_role_name = "ebs-csi-driver-role"
}
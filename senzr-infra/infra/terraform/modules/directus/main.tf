resource "helm_release" "directus" {
  name       = "directus"
  chart      = "directus"
  namespace  = var.directus_namespace
  repository = "https://your-helm-repo.com"
  version    = "x.y.z"

  values = [
    file("${path.module}/values.yaml")
  ]
}

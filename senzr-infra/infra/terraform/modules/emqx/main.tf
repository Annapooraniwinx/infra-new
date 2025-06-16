resource "helm_release" "emqx" {
  name       = "emqx"
  repository = "https://repos.emqx.io/charts"
  chart      = "emqx"
  version    = "5.0.15"
  namespace  = var.namespace

  values = [
    file("${path.module}/templates/emqx-values.yaml")
  ]
}

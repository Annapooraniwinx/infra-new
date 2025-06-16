resource "helm_release" "kong" {
  name       = "kong"
  repository = "https://charts.konghq.com"
  chart      = "kong"
  namespace  = "kong"
  version    = "2.18.0"

  values = [file("${path.module}/templates/kong-values.yaml")]
}

resource "helm_release" "pgbouncer" {
  name       = "pgbouncer"
  chart      = "bitnami/pgbouncer"
  namespace  = var.namespace
  values     = [file("${path.module}/templates/pgbouncer-values.yaml")]
}

resource "helm_release" "redis_sentinel" {
  name       = "redis-sentinel"
  chart      = "redis"
  repository = "https://charts.bitnami.com/bitnami"
  namespace  = var.redis_namespace
}

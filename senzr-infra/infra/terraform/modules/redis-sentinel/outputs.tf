output "release_name" {
  value = helm_release.redis_sentinel.name
}

output "namespace" {
  value = helm_release.redis_sentinel.namespace
}

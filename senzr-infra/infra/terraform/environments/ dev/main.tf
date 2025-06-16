module "redis_sentinel" {
  source          = "../../modules/redis-sentinel"
  redis_namespace = var.redis_namespace # Correct argument name
}

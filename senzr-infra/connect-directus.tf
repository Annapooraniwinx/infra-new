# Create this as connect-directus.tf
# This will automatically connect your existing Directus to the database

# Update Directus deployment environment variables
resource "kubernetes_config_map" "directus_env" {
  metadata {
    name      = "directus-env"
    namespace = "senzr"  # Correct namespace
  }

  data = {
    DB_CLIENT   = "pg"
    DB_HOST     = "directus-postgres.cjguq2ma02dv.ap-south-1.rds.amazonaws.com"
    DB_PORT     = "5432"
    DB_DATABASE = "directus"
    DB_USER     = "directus"
    DB_PASSWORD = "DirectsSecure123!"
    DB_SSL      = "true"
  }
}

# Patch existing Directus deployment to use new database
resource "null_resource" "update_directus" {
  depends_on = [kubernetes_config_map.directus_env]
  
  provisioner "local-exec" {
    command = <<-EOT
      # Update Directus deployment with new environment variables
      kubectl patch deployment directus-production -n senzr -p '{
        "spec": {
          "template": {
            "spec": {
              "containers": [{
                "name": "directus",
                "envFrom": [{
                  "configMapRef": {
                    "name": "directus-env"
                  }
                }]
              }]
            }
          }
        }
      }'
      
      # Restart Directus to pick up new database connection
      kubectl rollout restart deployment/directus-production -n senzr
    EOT
  }
}

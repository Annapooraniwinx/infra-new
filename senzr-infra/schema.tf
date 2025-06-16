# Create database and user (keep existing)
resource "postgresql_database" "directus" {
  name  = "directus"
  owner = "directus_admin"
}

resource "postgresql_role" "directus_user" {
  name     = "directus"
  login    = true
  password = "DirectsSecure123!"
}

resource "postgresql_grant" "directus_db_grant" {
  database    = postgresql_database.directus.name
  role        = postgresql_role.directus_user.name
  object_type = "database"
  privileges  = ["CONNECT", "CREATE", "TEMPORARY"]
}

# Comment out the problematic resource for now
# resource "null_resource" "create_tables" {
#   depends_on = [postgresql_grant.directus_db_grant]
#   
#   provisioner "local-exec" {
#     command = <<-EOT
#       echo "Tables will be created later"
#     EOT
#   }
# }

# Output connection info for Directus
output "directus_db_connection" {
  value = {
    host     = "directus-postgres.cjguq2ma02dv.ap-south-1.rds.amazonaws.com"
    port     = 5432
    database = "directus"
    user     = "directus"
    password = "DirectsSecure123!"
  }
  sensitive = true
}

output "kong_admin_url" {
  value = helm_release.kong.status[0].url
}

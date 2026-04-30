output "web_servers_public_ip" {
  value = yandex_compute_instance.web[*].network_interface[0].nat_ip_address
}

output "load_balancer_id" {
  value = yandex_alb_load_balancer.balancer.id
}

output "database_cluster_id" {
  value = yandex_mdb_postgresql_cluster.db.id
}

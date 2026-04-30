resource "yandex_dns_zone" "zone" {
  name        = "project-77-zone"
  description = "DNS zone for project 77"
  zone        = "mannkadevops.ru."
  public      = true
}

resource "yandex_dns_recordset" "record" {
  zone_id = yandex_dns_zone.zone.id
  name    = "mannkadevops.ru."
  type    = "A"
  ttl     = 300

  data = [yandex_alb_load_balancer.balancer.listener[0].endpoint[0].address[0].external_ipv4_address[0].address]
}

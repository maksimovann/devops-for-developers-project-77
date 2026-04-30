resource "yandex_vpc_network" "network" {
  name = "project-77-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "project-77-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

resource "yandex_compute_instance" "web" {
  count = 2

  name        = "web-${count.index + 1}"
  platform_id = "standard-v3"
  zone        = var.zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }
}

resource "yandex_mdb_postgresql_cluster" "db" {
  name        = "project-77-db"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.network.id

  config {
    version = 15

    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-hdd"
      disk_size          = 10
    }
  }

  host {
    zone      = var.zone
    subnet_id = yandex_vpc_subnet.subnet.id
  }
}

resource "yandex_mdb_postgresql_database" "db" {
  cluster_id = yandex_mdb_postgresql_cluster.db.id
  name       = var.db_name
  owner      = yandex_mdb_postgresql_user.user.name
}

resource "yandex_mdb_postgresql_user" "user" {
  cluster_id = yandex_mdb_postgresql_cluster.db.id
  name       = var.db_user
  password   = var.db_password
}

resource "yandex_alb_target_group" "web" {
  name = "project-77-target-group"

  dynamic "target" {
    for_each = yandex_compute_instance.web

    content {
      subnet_id  = yandex_vpc_subnet.subnet.id
      ip_address = target.value.network_interface[0].ip_address
    }
  }
}

resource "yandex_alb_backend_group" "web" {
  name = "project-77-backend-group"

  http_backend {
    name             = "web-backend"
    weight           = 1
    port             = 80
    target_group_ids = [yandex_alb_target_group.web.id]

    healthcheck {
      timeout  = "10s"
      interval = "10s"

      http_healthcheck {
        path = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "router" {
  name = "project-77-router"
}

resource "yandex_alb_virtual_host" "host" {
  name           = "project-77-host"
  http_router_id = yandex_alb_http_router.router.id

  route {
    name = "main-route"

    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.web.id
      }
    }
  }
}

resource "yandex_alb_load_balancer" "balancer" {
  name = "project-77-balancer"

  network_id = yandex_vpc_network.network.id

  allocation_policy {
    location {
      zone_id   = var.zone
      subnet_id = yandex_vpc_subnet.subnet.id
    }
  }

  listener {
    name = "https-listener"

    endpoint {
      address {
        external_ipv4_address {}
      }

      ports = [443]
    }

    tls {
      default_handler {
        certificate_ids = [var.certificate_id]

        http_handler {
          http_router_id = yandex_alb_http_router.router.id
        }
      }
    }
  }
}

locals {
  username     = "yc-user"
  ssh_key_path = "~/.ssh/dev-hosts.pub"
}

data "yandex_compute_image" "container-image" {
  family = "ubuntu-2204-lts"
}

resource "random_password" "compute-password" {
  length  = 15
  upper   = true
  lower   = true
  numeric = true
  special = false
}

resource "yandex_compute_instance" "compute" {
  name        = "dev-compute-3"
  hostname    = "dev-compute-3"
  platform_id = "standard-v3"
  zone        = var.zone
  folder_id   = var.folder_id

  resources {
    cores         = 4
    memory        = 4
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.container-image.id
      type     = "network-hdd"
      size     = 100
    }
    auto_delete = true
  }

  network_interface {
    subnet_id          = "e9buq42831js9ht9oqld"
    security_group_ids = ["enptqt7t6605o30ftsnd"]
    nat                = true
    ipv4               = true
  }

  metadata = {
    user-data = templatefile("./cloud-init.yaml",
      {
        ssh_key_path = file("${local.ssh_key_path}"),
        username     = local.username,
        passwd       = random_password.compute-password.bcrypt_hash,
    })
  }
}

data "yandex_compute_instance" "compute" {
  instance_id = yandex_compute_instance.compute.id
}

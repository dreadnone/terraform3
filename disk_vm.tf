resource "yandex_compute_disk" "vm_disk" {
  count = var.disk_count
  name  = "vm-disk-${count.index + 1}"
  type  = "network-hdd"
  zone  = var.default_zone
  size  = var.disk_size
}

resource "yandex_compute_instance" "storage_server" {
  name        = "storage"
  hostname    = "storage"
  platform_id = "standard-v1"

  resources {
    cores         = var.vm_base.cores
    memory        = var.vm_base.memory
    core_fraction = var.vm_base.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  dynamic "secondary_disk" {
    for_each = toset(yandex_compute_disk.vm_disk[*].id)
    content {
      disk_id = secondary_disk.value
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
  }

  scheduling_policy {
    preemptible = true
  }
  metadata = local.ssh_keys_and_serial_port
  allow_stopping_for_update = true
}
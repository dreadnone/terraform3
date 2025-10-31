resource "yandex_compute_instance" "web_server" {
  count    = 2
  name     = "web-${count.index + 1}"
  hostname = "web-${count.index + 1}"
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

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
  }

  scheduling_policy {
    preemptible = true
  }

   metadata = local.ssh_keys_and_serial_port

  depends_on = [yandex_compute_instance.database_server]

  allow_stopping_for_update = true
}
resource "yandex_compute_instance" "database_server" {
  for_each = { for vm in var.each_vm : vm.vm_name => vm }

  name        = each.value.vm_name
  hostname    = each.value.vm_name
  platform_id = "standard-v1"

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = var.vm_base.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = each.value.disk_volume
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
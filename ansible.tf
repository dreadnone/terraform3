locals {
  vm_groups = {
    webservers = {
      instances = yandex_compute_instance.web_server
      vars      = {}
    }
    databases = {
      instances = yandex_compute_instance.database_server
      vars      = {}
    }
    storage = {
      instances = [yandex_compute_instance.storage_server]
      vars      = {}
    }
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/hosts.tftpl",
    {
      groups = local.vm_groups
    }
  )
  filename = "${path.module}/inventory.ini"

  depends_on = [
    yandex_compute_instance.web_server,
    yandex_compute_instance.database_server,
    yandex_compute_instance.storage_server
  ]
}
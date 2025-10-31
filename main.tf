resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}
locals {
  ssh_keys_and_serial_port = {
    ssh-keys           = "ubuntu:${file("/home/andrew/.ssh/id_ed25519.pub")}"  
    serial-port-enable = 1
  }
}
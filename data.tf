data "yandex_compute_image" "ubuntu" {
  family = var.vm_base.family
}

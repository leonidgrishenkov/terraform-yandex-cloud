output "dev-compute-1-external-ip" {
  value = data.yandex_compute_instance.compute.network_interface.0.nat_ip_address
}
output "dev-compute-1-internal-ip" {
  value = data.yandex_compute_instance.compute.network_interface.0.ip_address
}

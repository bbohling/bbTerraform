output "floating_ip" {
  value = "${digitalocean_floating_ip.web-ip.ip_address}"
}

output "ip" {
  value = "${digitalocean_droplet.web.ipv4_address}"
}

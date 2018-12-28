variable "do_token" {
  "description" = "DigitalOcean Token: "
}

variable "do_droplet_region" {
  "description" = "DigitalOcean Droplet Region: "
  "default"     = "sfo2"
}

variable "do_droplet_size" {
  description = "DO droplet size (slug)"
  default     = "1GB"
}

variable "do_droplet_name" {
  "description" = "DigitalOcean Droplet Name: "
  "default"     = "bbTerraform"
}

variable "do_ssh_fingerprint" {
  "description" = "DigitalOcean SSH Fingerprint: "
}

variable "do_ssh_key" {
  "description" = "DigitalOcean SSH Key: "
}

## mariadb info

variable "db_admin_pass" {
  "description" = "MariaDB root password: "
}

variable "db_name" {
  "description" = "MariaDB application name: "
  "default"     = "bigdata"
}

variable "db_user" {
  "description" = "MariaDB application user: "
  "default"     = "crazydbuser"
}

variable "db_pass" {
  "description" = "MariaDB application password: "
}

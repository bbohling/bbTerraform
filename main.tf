# Used this to help create this: https://github.com/GetStream/stream-react-example
#
# Provider
#

provider "digitalocean" {
  token = "${var.do_token}"
}

#
# cloud-config
#
data "template_file" "userdata_web" {
  template = "${file("${path.module}/templates/web.yml.tpl")}"

  vars {
    userdata_sshkey                   = "${var.do_ssh_key}"
    userdata_nginx_dirtroadcollection = "${base64encode(file("${path.module}/files/dirtroadcollection.com"))}"
    userdata_index                    = "${base64encode(file("${path.module}/files/index.html"))}"
    userdata_nginx_brndn              = "${base64encode(file("${path.module}/files/brndn.me"))}"
    userdata_index_brndn              = "${base64encode(file("${path.module}/files/brndn.index.html"))}"
    userdata_nginx_bbi_brndn          = "${base64encode(file("${path.module}/files/bbi.brndn.me"))}"
    userdata_pm2_json                 = "${base64encode(file("${path.module}/files/sites.json"))}"
    userdata_localjs_bbi              = "${base64encode(file("${path.module}/files/bbi.local.js"))}"
  }
}

data "template_file" "install_mariadb_database" {
  template = "${file("${path.module}/templates/install_mariadb_database.yml.tpl")}"

  vars {
    db_admin_pass = "${var.db_admin_pass}"
    db_name       = "${var.db_name}"
    db_user       = "${var.db_user}"
    db_pass       = "${var.db_pass}"
  }
}

# data "template_file" "lets_encrypt" {
#   template = "${file("${path.module}/templates/lets_encrypt.yml.tpl")}"

#   vars {
#     token  = "${var.do_token}"
#     domain = "brndn.me"
#   }
# }

# Render a multi-part cloud-config
data "template_cloudinit_config" "bbterraform_config" {
  base64_encode = false
  gzip          = false

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.install_mariadb_database.rendered}"
    merge_type   = "list(append)+dict(recurse_array)+str()"
  }

  #   part {
  #     content_type = "text/cloud-config"
  #     content      = "${data.template_file.lets_encrypt.rendered}"
  #     merge_type   = "list(append)+dict(recurse_array)+str()"
  #   }

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.userdata_web.rendered}"
    merge_type   = "list(append)+dict(recurse_array)+str()"
  }
}

#
# Web instance
#

resource "digitalocean_floating_ip" "web-ip" {
  droplet_id = "${digitalocean_droplet.web.id}"
  region     = "${var.do_droplet_region}"
}

resource "digitalocean_droplet" "web" {
  image  = "ubuntu-18-04-x64"
  name   = "${var.do_droplet_name}"
  region = "${var.do_droplet_region}"
  size   = "${var.do_droplet_size}"

  ssh_keys = [
    "${var.do_ssh_fingerprint}",
  ]

  user_data = "${data.template_cloudinit_config.bbterraform_config.rendered}"
}

#
# Domains
#

# resource "digitalocean_domain" "default" {
#   name       = "dirtroadcollection.com"
#   ip_address = "${digitalocean_droplet.web.ipv4_address}"
# }

# resource "digitalocean_record" "CNAME-www" {
#   domain = "${digitalocean_domain.default.name}"
#   type   = "CNAME"
#   name   = "www"
#   value  = "@"
# }

resource "digitalocean_domain" "brndn" {
  name       = "brndn.me"
  ip_address = "${digitalocean_droplet.web.ipv4_address}"
}

resource "digitalocean_record" "brndn-www" {
  domain = "${digitalocean_domain.brndn.name}"
  type   = "CNAME"
  name   = "www"
  value  = "@"
}

resource "digitalocean_record" "brndn-bbi" {
  domain = "${digitalocean_domain.brndn.name}"
  type   = "A"
  name   = "bbi"
  value  = "${digitalocean_domain.brndn.ip_address}"
}

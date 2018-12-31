# bbTerraform

Just a little fun project I use to quickly spin up DigitalOcean droplets that includes DNS, SSH key, node.js, git, nginx, mariaDB, etc. to do dev work.

I am not an expert in this space, so if you have suggestions on how to improve please [create an issue](https://github.com/bbohling/bbTerraform/issues).

## Pre-reqs

A secrets file, `terraform.tfvars` is required to leverage this infrastructure as code plan. You will need to provide values for these variables:

* do_token
* do_ssh_fingerprint
* do_sshe_key
* db_admin_pass
* db_pass

## Post Install Steps

* # bbTerraform

## Post Install

* [Basic Firewall](https://www.digitalocean.com/community/tutorials/ufw-essentials-common-firewall-rules-and-commands)
```
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw delete allow 'Nginx HTTP'
sudo ufw allow ssh
ufw enable
```
* [Install SSL](https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-18-04)
```
sudo add-apt-repository ppa:certbot/certbot
sudo apt install python-certbot-nginx
sudo certbot --nginx -d bbi.brndn.me -d brndn.me
```

## TODO

- [ ] add some git repos for websites and APIs
- [ ] migrate all other domains

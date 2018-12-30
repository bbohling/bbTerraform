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

## TODO

- [ ] add some git repos for websites and APIs
- [ ] migrate all other domains

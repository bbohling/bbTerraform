#cloud-config
users:
  - name: bbohling
    groups: sudo
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    shell: /bin/bash
    lock_passwd: true
    ssh-authorized-keys:
      - ${userdata_sshkey}
disable_root: true
apt_update: true
package_update: true
package_upgrade: true
write_files:
  - encoding: b64
    content: ${userdata_nginx_dirtroadcollection}
    path: /tmp/web.conf
  - encoding: b64
    content: ${userdata_index}
    path: /tmp/index.html
    permissions: '0664'
  - encoding: b64
    content: ${userdata_nginx_brndn}
    path: /tmp/brndn.com
  - encoding: b64
    content: ${userdata_nginx_bbi_brndn}
    path: /tmp/bbi.brndn.com
packages:
 - nginx
 - git
 - nodejs
 - npm
runcmd:
  - sed -i -e '/^PermitRootLogin/s/^.*$/PermitRootLogin no/' /etc/ssh/sshd_config
  - sed -i -e '$aAllowUsers bbohling' /etc/ssh/sshd_config
  - restart ssh
  - apt-get update --fix-missing
  - mv /tmp/index.html /usr/share/nginx/dirtroadcollection.com/index.html
  - mv /tmp/web.conf /etc/nginx/sites-available/dirtroadcollection.com
  - ln -s /etc/nginx/sites-available/dirtroadcollection.com /etc/nginx/sites-enabled
  - mkdir /usr/share/nginx/dirtroadcollection.com
  - mv /tmp/brndn.com /etc/nginx/sites-available/brndn.com
  - ln -s /etc/nginx/sites-available/brndn.com /etc/nginx/sites-enabled
  - mkdir /usr/share/nginx/brndn.com
  - mv /tmp/bbi.brndn.com /etc/nginx/sites-available/bbi.brndn.com
  - ln -s /etc/nginx/sites-available/bbi.brndn.com /etc/nginx/sites-enabled
  - mkdir /usr/share/nginx/bbi.brndn.com
  - rm /etc/nginx/sites-enabled/default
  - rm /etc/nginx/sites-available/default
  - service nginx reload
  - npm install -g pm2
  - curl -sSL https://agent.digitalocean.com/install.sh | sh
final_message: "The system is finally up, after $UPTIME seconds"

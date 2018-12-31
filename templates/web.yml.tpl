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
    path: /tmp/brndn.me
  - encoding: b64
    content: ${userdata_index_brndn}
    path: /tmp/brndn.index.html
  - encoding: b64
    content: ${userdata_nginx_bbi_brndn}
    path: /tmp/bbi.brndn.me
  - encoding: b64
    content: ${userdata_pm2_json}
    path: /tmp/sites.json
  - encoding: b64
    content: ${userdata_localjs_bbi}
    path: /tmp/bbi.local.js
packages:
 - nginx
 - git
 - nodejs
 - npm
runcmd:
  - sudo -i
  - sed -i -e '/^PermitRootLogin/s/^.*$/PermitRootLogin no/' /etc/ssh/sshd_config
  - sed -i -e '$aAllowUsers bbohling' /etc/ssh/sshd_config
  - restart ssh
  - apt-get update --fix-missing
  - mv /tmp/index.html /usr/share/nginx/dirtroadcollection.com/index.html
  - mv /tmp/web.conf /etc/nginx/sites-available/dirtroadcollection.com
  - ln -s /etc/nginx/sites-available/dirtroadcollection.com /etc/nginx/sites-enabled
  - mkdir /usr/share/nginx/dirtroadcollection.com
  - mv /tmp/brndn.me /etc/nginx/sites-available/brndn.me
  - ln -s /etc/nginx/sites-available/brndn.me /etc/nginx/sites-enabled
  - mkdir /usr/share/nginx/brndn.me
  - mv /tmp/brndn.index.html /usr/share/nginx/brndn.me/index.html
  - mv /tmp/bbi.brndn.me /etc/nginx/sites-available/bbi.brndn.me
  - ln -s /etc/nginx/sites-available/bbi.brndn.me /etc/nginx/sites-enabled
  - mkdir /usr/share/nginx/bbi.brndn.me
  - cd /usr/share/nginx
  - git clone https://github.com/bbohling/lifestream-api.git bbi.brndn.me
  - cd /usr/share/nginx/bbi.brndn.me
  - npm install
  - mv /tmp/bbi.local.js /usr/share/nginx/bbi.brndn.me/config/local.js
  - rm /etc/nginx/sites-enabled/default
  - rm /etc/nginx/sites-available/default
  - service nginx reload
  - npm install -g pm2
  - mv /tmp/sites.json /usr/share/nginx/sites.json
  - curl -sSL https://agent.digitalocean.com/install.sh | sh
  - pm2 startup ubuntu
  - pm2 start /usr/share/nginx/sites.json
  - pm2 save
  - curl http://localhost:1337/v1/ingest/brandon?getAll=true
  - curl http://localhost:1337/v1/ingest/dave?getAll=true
  - sudo reboot

final_message: "The system is finally up, after $UPTIME seconds"

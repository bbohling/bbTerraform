packages:
  #jq is a command-line json processor https://stedolan.github.io/jq/
  - jq
  - unattended-upgrades
runcmd:
  - export DOMAIN=${domain}
  - export DO_API_TOKEN=${token}
  - export PUBLIC_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)
  - export DROPLET_ID=$(curl -s http://169.254.169.254/metadata/v1/id)
  - export DROPLET_NAME=$(curl -s http://169.254.169.254/metadata/v1/hostname)
  # get the email for letsencrypt from do api
  - 'export EMAIL=$(curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $DO_API_TOKEN"  https://api.digitalocean.com/v2/account  | jq -r ".account.email")'
  # install certbot, update
  - add-apt-repository ppa:certbot/certbot -y
  - apt-get update
  - apt install python-certbot-nginx -y
  # add domain name to nginx config, restart it
  - sed -i 's/server_name _;/server_name '$DROPLET_NAME"."$DOMAIN';/' /etc/nginx/sites-available/brndn.me
  - systemctl restart nginx
  - certbot --nginx -n -d $DROPLET_NAME"."$DOMAIN --email $EMAIL --agree-tos --redirect --hsts
  - systemctl reboot
# add renewal cron
write_files:
  - owner: root:root
    path: /etc/cron.d/letsencrypt_renew
    content: "15 3 * * * /usr/bin/certbot renew --quiet"

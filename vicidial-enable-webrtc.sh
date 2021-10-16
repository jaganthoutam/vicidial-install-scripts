#!/bin/bash
echo "Download PBXWebPhone agc"
cd /var/www/html/agc/
git clone https://github.com/chornyitaras/PBXWebPhone.git

echo "Enter the DOMAIN NAME HERE. ***********IF YOU DONT HAVE ONE PLEASE DONT CONTINUE: "
read DOMAINNAME

yum -y install certbot python2-certbot-apache mod_ssl


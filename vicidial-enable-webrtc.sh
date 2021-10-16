#!/bin/bash

echo "Download PBXWebPhone agc"
cd /var/www/html/agc/
git clone https://github.com/chornyitaras/PBXWebPhone.git

echo "Install certbot for LetsEncrypt"
yum -y install certbot python2-certbot-apache mod_ssl

echo "Enter the DOMAIN NAME HERE. ***********IF YOU DONT HAVE ONE PLEASE DONT CONTINUE: "
read DOMAINNAME

wget -O /etc/httpd/conf.d/$DOMAINNAME.conf https://raw.githubusercontent.com/jaganthoutam/vicidial-install-centos7/main/DOMAINNAME.conf
sed -i s/DOMAINNAME/"$DOMAINNAME"/g /etc/httpd/conf.d/$DOMAINNAME.conf

echo "Please Enter EMAIL and Agree the Terms and Conditions "
certbot --apache -d $DOMAINNAME

echo "Change http.conf in Asterisk"
wget -O /etc/asterisk/http.conf https://raw.githubusercontent.com/jaganthoutam/vicidial-install-centos7/main/asterisk-http.conf
sed -i s/DOMAINNAME/"$DOMAINNAME"/g /etc/asterisk/http.conf

echo "Change sip.conf in Asterisk"
wget -O /etc/asterisk/sip.conf https://raw.githubusercontent.com/jaganthoutam/vicidial-install-centos7/main/asterisk-sip.conf
sed -i s/DOMAINNAME/"$DOMAINNAME"/g /etc/asterisk/sip.conf

echo "Reloading Asterisk"
rasterisk -x reload

echo "Add DOMAINAME servers web_socket_url"
echo "%%%%%%%%%%%%%%%This Wont work if you SET root Password%%%%%%%%%%%%%%%"
mysql -e "use asterisk; update servers set web_socket_url='wss://$DOMAINNAME:8089/ws';"

echo "Add DOMAINAME system_settings webphone_url"
echo "%%%%%%%%%%%%%%%This Wont work if you SET root Password%%%%%%%%%%%%%%%"
mysql -e "use asterisk; update system_settings set webphone_url='PBXWebPhone/index.php';"

echo "update the SIP_generic"
mysql -e "update vicidial_conf_templates set template_contents='type=friend \nhost=dynamic' where template_id='SIP_generic';"

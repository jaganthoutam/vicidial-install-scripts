#!/bin/sh

echo "Vicidial installation Ubuntu18 with WebPhone(WebRTC/SIP.js)"

sudo add-apt-repository ppa:ondrej/php  -y
sudo apt-get update
sudo apt-get install build-essential linux-headers-`uname -r` subversion unzip libjansson-dev sqlite autoconf automake  libxml2-dev libncurses5-dev libsqlite3-dev  -y 
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E5267A6C
sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
sudo add-apt-repository 'deb [arch=amd64,arm64,ppc64el] https://mariadb.mirror.liquidtelecom.com/repo/10.6/ubuntu bionic main'
sudo apt update 
sudo apt-get install apache2 apache2-bin apache2-data libapache2-mod-php5.6 php5.6 php5.6-xcache php5.6-dev php5.6-mbstring php5.6-cli php5.6-common php5.6-json php5.6-mysql php5.6-readline sox lame screen libnet-telnet-perl php5.6-mysqli libasterisk-agi-perl mariadb-server mariadb-client libelf-dev autogen libtool shtool libdbd-mysql-perl libmysqlclient-dev libsrtp-dev uuid-dev libssl-dev git curl wget -y
#Special package for ASTblind and ASTloop(ip_relay need this package)
apt-get install libc6-i386

#Install Jansson
cd /usr/src/
wget http://www.digip.org/jansson/releases/jansson-2.5.tar.gz
tar -zxf jansson-2.5.tar.gz
#tar xvzf jasson*
cd jansson-2.5
./configure
make clean
make
make install 
ldconfig

#Install CPAMN
cd /usr/bin/
apt install cpanminus -y
curl -LOk http://xrl.us/cpanm
chmod +x cpanm
cpanm readline --force
read -p 'Press Enter to continue Install perl modules: '

cpanm -f File::HomeDir
cpanm -f File::Which
cpanm CPAN::Meta::Requirements
cpanm -f CPAN
cpanm YAML
cpanm MD5
cpanm Digest::MD5
cpanm Digest::SHA1
cpanm Bundle::CPAN
cpanm DBI
cpanm -f DBD::mysql
cpanm Net::Telnet
cpanm Time::HiRes
cpanm Net::Server
cpanm Switch
cpanm Mail::Sendmail
cpanm Unicode::Map
cpanm Jcode
cpanm Spreadsheet::WriteExcel
cpanm OLE::Storage_Lite
cpanm Proc::ProcessTable
cpanm IO::Scalar
cpanm Spreadsheet::ParseExcel
cpanm Curses
cpanm Getopt::Long
cpanm Net::Domain
cpanm Term::ReadKey
cpanm Term::ANSIColor
cpanm Spreadsheet::XLSX
cpanm Spreadsheet::Read
cpanm LWP::UserAgent
cpanm HTML::Entities
cpanm HTML::Strip
cpanm HTML::FormatText
cpanm HTML::TreeBuilder
cpanm Time::Local
cpanm MIME::Decoder
cpanm Mail::POP3Client
cpanm Mail::IMAPClient
cpanm Mail::Message
cpanm IO::Socket::SSL
cpanm MIME::Base64
cpanm MIME::QuotedPrint
cpanm Crypt::Eksblowfish::Bcrypt
cpanm Crypt::RC4
cpanm Text::CSV
cpanm Text::CSV_XS

#If the DBD::MYSQL Fail Run below Command
apt install libdbd-mysql-perl



read -p 'Press Enter to continue And Install Dahdi: '
#Install dahdi
apt-get install dahdi-* dahdi
modprobe dahdi
modprobe dahdi_dummy
/usr/sbin/dahdi_cfg -vvvvvvvvvvvvv

read -p 'Press Enter to continue And Install LibPRI and Asterisk: '

#Install Asterisk 
mkdir /usr/src/asterisk
cd /usr/src/asterisk
wget http://download.vicidial.com/required-apps/asterisk-13.29.2-vici.tar.gz  
tar -xvf asterisk-13.29.2-vici.tar.gz
cd asterisk-13.29.2
: ${JOBS:=$(( $(nproc) + $(nproc) / 2 ))}
./configure --libdir=/usr/lib --with-gsm=internal --enable-opus --enable-srtp --with-ssl --enable-asteriskssl --with-pjproject-bundled --without-ogg
make menuselect/menuselect menuselect-tree menuselect.makeopts
#enable app_meetme
menuselect/menuselect --enable app_meetme menuselect.makeopts
#enable res_http_websocket
menuselect/menuselect --enable res_http_websocket menuselect.makeopts
#enable res_srtp
menuselect/menuselect --enable res_srtp menuselect.makeopts
make -j ${JOBS} all
make install
make samples


read -p 'Press Enter to continue: '
echo 'Continuing...'
#Install astguiclient
echo "Installing astguiclient"
mkdir /usr/src/astguiclient
cd /usr/src/astguiclient
svn checkout svn://svn.eflo.net/agc_2-X/trunk
cd /usr/src/astguiclient/trunk
#Add mysql users and Databases
echo "%%%%%%%%%%%%%%%Please Enter Mysql Password Or Just Press Enter if you Dont have Password%%%%%%%%%%%%%%%%%%%%%%%%%%"
mysql -u root -p << MYSQLCREOF
CREATE DATABASE asterisk DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE USER 'cron'@'localhost' IDENTIFIED BY '1234';
GRANT SELECT,INSERT,UPDATE,DELETE,LOCK TABLES on asterisk.* TO cron@'%' IDENTIFIED BY '1234';
CREATE USER 'custom'@'localhost' IDENTIFIED BY 'custom1234';
GRANT SELECT,INSERT,UPDATE,DELETE,LOCK TABLES on asterisk.* TO custom@'%' IDENTIFIED BY 'custom1234';
GRANT SELECT,INSERT,UPDATE,DELETE,LOCK TABLES on asterisk.* TO cron@localhost IDENTIFIED BY '1234';
GRANT SELECT,INSERT,UPDATE,DELETE,LOCK TABLES on asterisk.* TO custom@localhost IDENTIFIED BY 'custom1234';
GRANT RELOAD ON *.* TO cron@'%';
GRANT RELOAD ON *.* TO cron@localhost;
GRANT RELOAD ON *.* TO custom@'%';
GRANT RELOAD ON *.* TO custom@localhost;
flush privileges;
use asterisk;
\. /usr/src/astguiclient/trunk/extras/MySQL_AST_CREATE_tables.sql
\. /usr/src/astguiclient/trunk/extras/first_server_install.sql
update servers set asterisk_version='13.29.2';
quit
MYSQLCREOF
read -p 'Press Enter to continue: '
echo 'Continuing...'
#Get astguiclient.conf file
echo "" > /etc/astguiclient.conf
wget -O /etc/astguiclient.conf https://raw.githubusercontent.com/jaganthoutam/vicidial-install-scripts/main/astguiclient.conf
echo "Replace IP address in Default"
echo "%%%%%%%%%Please Enter This Server IP ADD%%%%%%%%%%%%"
read serveripadd
sed -i 's/$serveripadd/'$serveripadd'/g' /etc/astguiclient.conf
echo "Install VICIDIAL"
echo "Copy sample configuration files to /etc/asterisk/ SET TO  Y*"
perl install.pl
#Secure Manager 
sed -i s/0.0.0.0/127.0.0.1/g /etc/asterisk/manager.conf
echo "Populate AREA CODES"
/usr/share/astguiclient/ADMIN_area_code_populate.pl
echo "Replace OLD IP. You need to Enter your Current IP here"
/usr/share/astguiclient/ADMIN_update_server_ip.pl --old-server_ip=10.10.10.15

#Install Crontab
wget -O /root/crontab-file https://raw.githubusercontent.com/jaganthoutam/vicidial-install-scripts/main/crontab
crontab /root/crontab-file
crontab -l

#Install rc.local
wget -O /etc/rc.local https://raw.githubusercontent.com/jaganthoutam/vicidial-install-scripts/main/rc.local
chmod +x /etc/rc.local
systemctl start rc-local
read -p 'Press Enter to Reboot: '
echo "Restarting Centos"
reboot






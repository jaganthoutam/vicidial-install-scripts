#!/bin/sh

echo "Vicidial installation Centos7 with WebPhone(WebRTC/SIP.js)"

export LC_ALL=C

yum install make patch gcc perl-Term-ReadLine-Gnu gcc-c++ subversion php php-devel php-gd gd-devel php-mbstring php-mcrypt php-imap php-ldap php-mysql php-odbc php-pear php-xml php-xmlrpc curl curl-devel perl-libwww-perl ImageMagick libxml2 libxml2-devel httpd libpcap libpcap-devel libnet ncurses ncurses-devel screen mysql-devel ntp mutt glibc.i686 wget nano unzip sipsak sox libss7* libopen* openssl libsrtp libsrtp-devel unixODBC unixODBC-devel libtool-ltdl libtool-ltdl-devel -y
yum -y install sqlite-devel
yum install mariadb-server mariadb -y

cp /etc/my.cnf /etc/my.cnf.original

echo "" > /etc/my.cnf


cat <<MYSQLCONF>> /etc/my.cnf
[mysql.server]
user = mysql
#basedir = /var/lib

[client]
port = 3306
socket = /var/lib/mysql/mysql.sock

[mysqld]
datadir = /var/lib/mysql
#tmpdir = /home/mysql_tmp
socket = /var/lib/mysql/mysql.sock
user = mysql
old_passwords = 0
ft_min_word_len = 3
max_connections = 800
max_allowed_packet = 32M
skip-external-locking

log-error = /var/log/mysqld/mysqld.log

query-cache-type = 1
query-cache-size = 32M

long_query_time = 1
#slow_query_log = 1
#slow_query_log_file = /var/log/mysqld/slow-queries.log

tmp_table_size = 128M
table_cache = 1024

join_buffer_size = 1M
key_buffer = 512M
sort_buffer_size = 6M
read_buffer_size = 4M
read_rnd_buffer_size = 16M
myisam_sort_buffer_size = 64M

max_tmp_tables = 64

thread_cache_size = 8
thread_concurrency = 8

# If using replication, uncomment log-bin below
#log-bin = mysql-bin

[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash

[isamchk]
key_buffer = 256M
sort_buffer_size = 256M
read_buffer = 2M
write_buffer = 2M

[myisamchk]
key_buffer = 256M
sort_buffer_size = 256M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout

[mysqld_safe]
#log-error = /var/log/mysqld/mysqld.log
#pid-file = /var/run/mysqld/mysqld.pid

MYSQLCONF

#Enable and Start httpd and MariaDb
systemctl enable httpd.service
systemctl enable mariadb.service
systemctl restart httpd.service
systemctl restart mariadb.service

#Install Perl Modules

echo "Install Perl"

yum install perl-CPAN -y
yum install perl-YAML -y
yum install perl-libwww-perl -y
yum install perl-DBI -y
yum install perl-DBD-MySQL -y
yum install perl-GD -y

echo "Please Press ENTER for CPAN Install"

yum install perl-CPAN -y
yum install perl-YAML -y
yum install perl-libwww-perl -y
yum install perl-DBI -y
yum install perl-DBD-MySQL -y
yum install perl-GD -y
cd /usr/bin/
curl -LOk http://xrl.us/cpanm
chmod +x cpanm
cpanm -f File::HomeDir
cpanm -f File::Which
cpanm CPAN::Meta::Requirements
cpanm -f CPAN
cpanm YAML
cpanm MD5
cpanm Digest::MD5
cpanm Digest::SHA1
cpanm readline --force
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


#Install Asterisk Perl 
cd /usr/src
wget http://download.vicidial.com/required-apps/asterisk-perl-0.08.tar.gz
tar xzf asterisk-perl-0.08.tar.gz
cd asterisk-perl-0.08
perl Makefile.PL
make all
make install 

#Install SIPSack

cd /usr/src
wget http://download.vicidial.com/required-apps/sipsak-0.9.6-1.tar.gz
tar -zxf sipsak-0.9.6-1.tar.gz
cd sipsak-0.9.6
./configure
make
make install
/usr/local/bin/sipsak --version


#Install Lame
cd /usr/src
wget http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
tar -zxf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure
make
make install

#Install Jansson
cd /usr/src/
wget http://www.digip.org/jansson/releases/jansson-2.5.tar.gz
tar -zxf jansson-2.5.tar.gz
#tar xvzf jasson*
cd jansson*
./configure
make clean
make
make install 
ldconfig

cd /usr/src
wget https://github.com/eaccelerator/eaccelerator/zipball/master -O eaccelerator.zip
unzip eaccelerator.zip
cd eaccelerator-*
export PHP_PREFIX="/usr"
$PHP_PREFIX/bin/phpize
./configure --enable-eaccelerator=shared --with-php-config=$PHP_PREFIX/bin/php-config
make
make install

#Change PHP config

echo "Download the PHP ini file from Git"
wget -O /etc/php.ini https://raw.githubusercontent.com/jaganthoutam/vicidial-install-scripts/main/php.ini

mkdir /tmp/eaccelerator
chmod 0777 /tmp/eaccelerator
php -v

echo "Donwload httpd.cof file from git"
wget -O /etc/httpd/conf/httpd.conf https://raw.githubusercontent.com/jaganthoutam/vicidial-install-scripts/main/httpd.conf


#Install Dahdi
echo "Install Dahdi"
yum install dahdi-* -y
wget http://download.vicidial.com/beta-apps/dahdi-linux-complete-2.11.1.tar.gz
tar xzf dahdi-linux-complete-2.11.1.tar.gz
cd dahdi-linux-complete-2.11.1+2.11.1
make all
make install
modprobe dahdi
modprobe dahdi_dummy
make config
cp /etc/dahdi/system.conf.sample /etc/dahdi/system.conf
/usr/sbin/dahdi_cfg -vvvvvvvvvvvvv

read -p 'Press Enter to continue: '

echo 'Continuing...'

#Install Asterisk and LibPRI
mkdir /usr/src/asterisk
cd /usr/src/asterisk
wget http://downloads.asterisk.org/pub/telephony/libpri/libpri-current.tar.gz
wget http://download.vicidial.com/required-apps/asterisk-13.29.2-vici.tar.gz


tar -xvzf asterisk-*
tar -xvzf libpri-*

cd /usr/src/asterisk/asterisk*

: ${JOBS:=$(( $(nproc) + $(nproc) / 2 ))}
./configure --libdir=/usr/lib --with-gsm=internal --enable-opus --enable-srtp --with-ssl --enable-asteriskssl --with-pjproject-bundled

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
sed -i s/SERVERIP/"$serveripadd"/g /etc/astguiclient.conf

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
> /etc/rc.d/rc.local
wget -O /etc/rc.d/rc.local https://raw.githubusercontent.com/jaganthoutam/vicidial-install-scripts/main/rc.local
chmod +x /etc/rc.d/rc.local
systemctl enable rc-local
systemctl start rc-local

read -p 'Press Enter to Reboot: '

echo "Restarting Centos"

reboot

#!/bin/sh

echo "Vicidial installation Centos7 with WebPhone(WebRTC/SIP.js)"

export LC_ALL=C

yum check-update
yum update -y
yum -y install epel-release 
yum groupinstall 'Development Tools'

#Disable SELINUX
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config    
systemctl disable firewalld
#reboot

yum install make patch gcc perl-Term-ReadLine-Gnu gcc-c++ subversion php php-devel php-gd gd-devel php-mbstring php-mcrypt php-imap php-ldap php-mysql php-odbc php-pear php-xml php-xmlrpc curl curl-devel perl-libwww-perl ImageMagick libxml2 libxml2-devel httpd libpcap libpcap-devel libnet ncurses ncurses-devel screen mysql-devel ntp kernel* mutt glibc.i686 wget nano unzip sipsak sox libss7* libopen* openssl libsrtp libsrtp-devel unixODBC unixODBC-devel libtool-ltdl libtool-ltdl-devel -y
yum install sqlite-devel –y
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
systemctl start httpd.service
systemctl start mariadb.service

#Install Perl Modules

echo "Install Perl"

yum install perl-CPAN -y
yum install perl-YAML -y
yum install perl-libwww-perl -y
yum install perl-DBI -y
yum install perl-DBD-MySQL -y
yum install perl-GD -y

yum install -y  mod_ssl perl-DBI perl-DBD-MySQL perl-Digest-HMAC perl-YAML perl-ExtUtils-ParseXS perl-NetAddr-IP perl-Crypt-SSLeay perl-Curses perl-DBD-Pg perl-Module-ScanDeps perl-Text-CSV perl-HTML-Template perl-IO-Compress perl-Text-Glob perl-Jcode perl-Test-Script perl-Archive-Tar perl-Test-Base perl-OLE-Storage_Lite perl-Archive-Zip perl-Net-Server perl-Convert-ASN1 perl perl-Compress-Raw-Zlib perl-Digest-SHA1 perl-Data-Dumper perl-Error perl-ExtUtils-CBuilder perl-Test-Tester perl-Parse-RecDescent perl-Spiffy perl-IO-Zlib perl-Module-Build perl-HTML-Parser perl-Net-SSLeay perl-Proc-ProcessTable perl-TermReadKey perl-Term-ReadLine-Gnu perl-Digest-SHA perl-Tk perl-Net-SNMP perl-Test-NoWarnings perl-XML-Writer perl-Proc-PID-File perl-Compress-Raw-Bzip2 perl-libwww-perl perl-XML-Parser perl-File-Remove perl-Parse-CPAN-Meta perl-Set-Scalar perl-Probe-Perl perl-File-Which perl-Package-Constants perl-Module-Install perl-File-HomeDir perl-Spreadsheet-ParseExcel perl-Mail-Sendmail perl-Spreadsheet-XLSX asterisk-perl perl-version perl-Crypt-DES perl-URI perl-Net-Daemon perl-IO-stringy perl-YAML-Tiny perl-HTML-Tagset perl-Socket6 perl-BSD-Resource perl-PlRPC perl-IPC-Run3 perl-Text-CSV_XS perl-Unicode-Map perl-Module-CoreList perl-Net-Telnet perl-PAR-Dist perl-Date-Manip perl-JSON perl-Proc-Daemon perl-Spreadsheet-WriteExcel perl-rrdtool install lame screen sox ntp iftop subversion dahdi-linux-devel php-xcache wget nano vim readline-devel 

echo "Please Press ENTER for CPAN Install"
cpan -i String::CRC Tk::TableMatrix Net::Address::IP::Local Term::ReadLine::Gnu Spreadsheet::Read Net::Address::IPv4::Local RPM::Specfile Spreadsheet::XLSX Spreadsheet::ReadSXC


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
wget -O /etc/php.ini https://raw.githubusercontent.com/jaganthoutam/vicidial-install-centos7/main/php.ini

mkdir /tmp/eaccelerator
chmod 0777 /tmp/eaccelerator
php -v

echo "Donwload httpd.cof file from git"
wget -O /etc/httpd/conf/httpd.conf https://raw.githubusercontent.com/jaganthoutam/vicidial-install-centos7/main/httpd.conf


#Install Dahdi
echo "Install Dahdi"
yum install dahdi-* -y
modprobe dahdi
/usr/sbin/dahdi_cfg -vvvvvvvvvvvvv

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
quit
MYSQLCREOF

#Get astguiclient.conf file
cd /root
echo "" > /etc/astguiclient.conf
wget -O /etc/astguiclient.conf https://raw.githubusercontent.com/jaganthoutam/vicidial-install-centos7/main/astguiclient.conf

#Install Crontab
wget -O /root/crontab-file https://raw.githubusercontent.com/jaganthoutam/vicidial-install-centos7/main/crontab
crontab /root/crontab-file


#Install rc.local
> /etc/rc.d/rc.local
wget -O /etc/rc.d/rc.local https://raw.githubusercontent.com/jaganthoutam/vicidial-install-centos7/main/rc.local
chmod +x /etc/rc.d/rc.local
systemctl enable rc-local
systemctl start rc-local

echo "Restarting Centos"
reboot

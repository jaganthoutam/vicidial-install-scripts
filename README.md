# Install pre_requisites for vididial 



```
yum check-update
yum update -y
yum -y install epel-release
yum update -y
yum groupinstall 'Development Tools' -y
yum install git -y
yum install kernel*

#Disable SELINUX
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config    
systemctl disable firewalld

reboot
````
  Reboot Before running this script

#Install VICIDIAL Now

```
yum install git -y
git clone https://github.com/jaganthoutam/vicidial-install-centos7.git
cd vicidial-install-centos7
chmod +x vicidial-install.sh
./vicidial-install.sh
```

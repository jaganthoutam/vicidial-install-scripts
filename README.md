# VICIDIAL INSTALLATION SCRIPTS
# Centos vididial Install pre_requisites 

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

# Install VICIDIAL Now

```
git clone https://github.com/jaganthoutam/vicidial-install-centos7.git
cd vicidial-install-scripts
```

# Excute Centos vididial Install
```
chmod +x vicidial-install-centos7.sh
./vicidial-install-centos7.sh
```

# Excute Ubuntu vididial Install
```
chmod +x vicidial-install-ubuntu18.sh
./vicidial-install-ubuntu18.sh
```

# Install WEBRTC for VICIDIAL Now
# DO THIS IF YOU HAVE PUBLIC DOMAIN WITH PUBLIC IP ONLY

```
chmod +x vicidial-enable-webrtc.sh
./vicidial-enable-webrtc.sh
```

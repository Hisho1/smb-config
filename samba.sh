#! /bin/bash
####take the current user####
USERID=$(id -u)

echo "script to configure samba"

sleep 1
####checking if you are root####
if [ "${USERID}" -ne 0 ];
then
	echo "execute as root"
	exit
fi
####updating system####
sudo apt update

####checking if samba is in the system, if not, then install it####
if dpkg -s samba >/dev/null 2>&1;
then
	echo "samba is installed"
else
	echo "installing samba"
	sudo apt -y install samba
fi

sleep 1

#####back up default config#####
sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.bk

#####config files#####
sudo echo '[global]
server string = File server
workgroup = WORKGROUP
security = user
map to guest = Bad User
name resolve order = bcast host
include = /etc/samba/shares.conf'> /etc/samba/smb.conf

sudo echo '[Public Files]
path = /Smbshares/public_files
force user = smbuser
force group = smbgroup
create mask = 0664
force create mask = 0664
directory mask = 0775
force directory mask = 0775
public = yes
writeable = yes
[Protected Files]
path = /Smbshares/public_files
force user = smbuser
force group = smbgroup
create mask = 0664
force create mask = 0664
directory mask = 0775
force directory mask = 0775
public = yes
writeable = no'>/etc/samba/shares.conf
#####creating share directories#####
sudo mkdir -p /Smbshares/public_files
sudo mkdir /Smbshares/Protected_files
#####creating system users to granted #####
sudo groupadd --system smbgroup
sudo useradd --system --no-create-home --group smbgroup -s /bin/false smbuser
#####changing permission from share directory#####
sudo chown -R smbuser:smbgroup /Smbshares
sudo chmod -R g+w /Smbshares
#####restarting service#####
sudo systemctl restart smbd.service

echo "samba installed and configured"


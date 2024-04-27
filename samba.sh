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
apt update

####checking if samba is in the system, if not, then install it####
if dpkg -s samba >/dev/null 2>&1;
then
	echo "samba is installed"
else
	echo "installing samba"
	apt -y install samba
fi

sleep 1

#####back up default config#####
mv /etc/samba/smb.conf /etc/samba/smb.conf.bk

#####config files#####
echo '[global]
server string = File server
workgroup = WORKGROUP
security = user
map to guest = Bad User
name resolve order = bcast host
include = /etc/samba/shares.conf'> /etc/samba/smb.conf

echo '[Public Files]
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
mkdir -p /Smbshares/public_files
mkdir /Smbshares/Protected_files
#####creating system users to granted #####
groupadd --system smbgroup
useradd --system --no-create-home --group smbgroup -s /bin/false smbuser
#####changing permission from share directory#####
chown -R smbuser:smbgroup /Smbshares
chmod -R g+w /Smbshares
#####restarting service#####
systemctl restart smbd.service

echo "samba installed and configured"


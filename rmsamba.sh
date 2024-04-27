#! /bin/bash

###stopping service###
systemctl stop smbd.service

###uninstalling and purging all samba files###
apt remove --purge -y samba samba-*

###erasing all samba config user and share directory###
userdel smbuser
groupdel smbgroup
rm -r /Smbshares

echo "Samba fully desinstaled"

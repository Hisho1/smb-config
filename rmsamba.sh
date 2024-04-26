#! /bin/bash

###stopping service###
sudo systemctl stop smbd.service

###uninstalling and purging all samba files###
sudo apt remove --purge -y samba samba-*

###erasing all samba config user and share directory###
sudo userdel smbuser
sudo groupdel smbgroup
sudo rm -r /Smbshares

echo "Samba fully desinstaled"

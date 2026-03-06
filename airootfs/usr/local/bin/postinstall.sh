#!/bin/bash -e
#
##############################################################################
#
#  PostInstall is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 3 of the License, or
#  (at your discretion) any later version.
#
#  PostInstall is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
##############################################################################

 name=$(ls -1 /home)
 REAL_NAME=/home/$name

# genfstab -U / > /etc/fstab

#cp /cinnamon-configs/cinnamon-stuff/bin/* /bin/
#cp /cinnamon-configs/cinnamon-stuff/usr/bin/* /usr/bin/
#cp -r /cinnamon-configs/cinnamon-stuff/usr/share/* /usr/share/

mkdir /home/$name/.config
mkdir /home/$name/.config/caja
#mkdir -p /home/$name/.local/share/mate/extensions

#cp -r /mate-configs/mate-stuff/extensions/* /home/$name/.local/share/mate/extensions

#cp -r /mate-configs/mate-stuff/caja/* /home/$name/.config/caja

cp -r /mate-configs/mate-stuff/.config/* /home/$name/.config/

mkdir /home/$name/.config/autostart

cp -r /mate-configs/dd.desktop /home/$name/.config/autostart

chown -R $name:$name /home/$name/.config
chown -R $name:$name /middle.png
#mv /middle.png /home/$USER

cp -r /mate-configs/.bashrc /home/$name/.bashrc
cp -r /mate-configs/.bashrc /root
cp -r /mate-configs/AcreetionOS.txt /root
cp -r /mate-configs/AcreetionOS.txt /home/$name/AcreetionOS.txt

mv /resolv.conf /etc/resolv.conf
chattr +i /etc/resolv.conf
chattr +i /etc/os-release

# create python fix!

#mkdir -p /usr/lib/python3.13/site-packages/six
#touch /usr/lib/python3.13/site-packages/six/__init__.py
#cp /usr/lib/python3.12/site-packages/six.py /usr/lib/python3.13/site-packages/six/six.py

# cp /archiso.conf /etc/mkinitcpio.conf.d/archiso.conf

# mkdir /home/$name/.local/share/mate

# cp -r /mate-configs/mate-stuff/extensions /home/$name/.local/share/mate/

cp /mate-configs/AcreetionOS.txt /home/$name/

mkdir -p /usr/share/backgrounds
cp -r /backgrounds /usr/share/backgrounds
rm -rf /backgrounds

# chsh -s /bin/bash root

echo "Defaults pwfeedback" | sudo EDITOR='tee -a' visudo >/dev/null 2>&1

#cp -r /mate-configs/spices/* /home/$name/.config/mate/spices/
cp /etc/pacman2.conf pacman.conf
cp /mkinitcpio/mkinitcpio.conf /etc/mkinitcpio.conf
# Don't copy archiso.conf - it's only for the live ISO
# cp /mkinitcpio/archiso.conf /etc/mkinitcpio.conf.d/archiso.conf
cp /mate-configs/.nanorc /home/$name/.nanorc

# Create placeholder dm-initramfs.rules for archiso hook compatibility
# mkdir -p /usr/lib/initcpio/udev
# echo "# Placeholder file for archiso hook compatibility" > /usr/lib/initcpio/udev/11-dm-initramfs.rules
# echo "# dm-initramfs rules not needed since lvm2 is not included in this ISO" >> /usr/lib/initcpio/udev/11-dm-initramfs.rules

# Remove archiso config if it exists
rm -f /etc/mkinitcpio.conf.d/archiso.conf

rm -rf /mkinitcpio
rm -rf mate-configs

#sudo pacman -S updater --noconfirm --overwrite '*'

chown $name:$name /home/$name/.nanorc

# copy the new pacman over full of color!

cp /usr/bin/pacman2 /usr/bin/pacman

# fix lightdm issue after install

rm -rf /etc/systemd/system/display-manager.service
systemctl enable lightdm.service
systemctl daemon-reload

# rm /etc/xdg/autostart/calamares.desktop

exit 0


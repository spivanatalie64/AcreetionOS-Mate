#!/bin/bash
# Minimal Calamares Launcher

# Ensure initcpio config is correct for installed system
cp /mkinitcpio/mkinitcpio.conf /etc/mkinitcpio.conf

# Launch Calamares
# -d 8 enables debug logging (level 8)
calamares -d 8 > /root/calamares.log

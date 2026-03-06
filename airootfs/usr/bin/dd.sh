#!/bin/bash
/usr/bin/acreetion-welcome.sh &

dconf load / < /mate.dconf
dconf load /org/mate/terminal/ < /terminal-settings

cp /usr/bin/pacman2 /usr/bin/pacman

rm $HOME/.config/autostart/dd.desktop
cp /mate-configs/.bashrc /root


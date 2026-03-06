#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="AcreetionOS-Lite"
iso_label="acreetionos_lite_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="Acreetion OS"
iso_application="Acreetion OS Lite Install Media"
iso_version="1.0"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-ia32.grub.esp' 'uefi-x64.grub.esp' 'uefi-ia32.grub.eltorito' 'uefi-x64.grub.eltorito')
arch="${ARCH:-x86_64}"
pacman_conf="pacman.${arch}.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' "$(if [ "$arch" = "x86_64" ] || [ "$arch" = "i686" ]; then echo "x86"; elif [ "$arch" = "aarch64" ] || [ "$arch" = "armv7h" ]; then echo "arm"; else echo "none"; fi)" '-b' '1M' '-Xdict-size' '1M')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/root/.gnupg"]="0:0:700"
  ["/usr/local/bin/choose-mirror"]="0:0:755"
  ["/usr/local/bin/Installation_guide"]="0:0:755"
  ["/usr/local/bin/livecd-sound"]="0:0:755"
  ["/usr/bin/calamares"]="0:0:755"
#  ["/usr/lib/calamares/modules/*"]="0:0:755"
  ["/root/cinstall"]="0:0:755"
  ["/root/cinstall2"]="0:0:755"
  ["/root/zone"]="0:0:755"
  ["/usr/bin/fixkeys.sh"]="0:0:755"
  ["/usr/bin/acreetion-welcome.sh"]="0:0:755"
  ["/usr/bin/dd.sh"]="0:0:755"
  ["/usr/bin/acreetion-net-setup.sh"]="0:0:755"
  ["/usr/bin/acreetion-simple-install"]="0:0:755"
  ["/usr/local/bin/acreetionosinstall"]="0:0:755"
  ["/usr/local/bin/postinstall.sh"]="0:0:755"
  ["/usr/bin/calamares.sh"]="0:0:755"
  ["/usr/local/bin/preinstall"]="0:0:755"
  ["/usr/local/bin/stormos-final"]="0:0:755"
  ["/usr/bin/wifi-connection"]="0:0:755"
  ["/usr/local/bin/setup-displays.sh"]="0:0:755"
  ["/usr/local/bin/generate-serial.sh"]="0:0:755"
  ["/usr/local/bin/build-date"]="0:0:755"
)

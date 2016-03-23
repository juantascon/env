#requirements: partiton - format - mount

#set these vars
hostname=hostname
drive=/dev/vda

pacstrap /mnt base base-devel vim wget net-tools ipset ethtool grub openssh
genfstab -L -p /mnt >> /mnt/etc/fstab
echo $hostname > /mnt/etc/hostname
ln -s /usr/share/zoneinfo/America/Bogota /mnt/etc/localtime
echo en_US.UTF-8 UTF-8 >> /mnt/etc/locale.gen
echo LANG=en_US.UTF-8 > /mnt/etc/locale.conf
arch-chroot /mnt locale-gen
arch-chroot /mnt grub-mkconfig > /mnt/boot/grub/grub.cfg
arch-chroot /mnt grub-install $drive
arch-chroot /mnt passwd

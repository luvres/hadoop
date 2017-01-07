#!/bin/bash

# ssh-keygen -f "$HOME/.ssh/known_hosts" -R 191.96.255.110

MOUNTPOINT="/mnt"
USER="luvres"
PASS="aamu02"
RPASS="aamu02"

arch_chroot(){
	arch-chroot $MOUNTPOINT /bin/bash -c "${1}"
}

pacstrap /mnt base base-devel btrfs-progs ntp openssh wget git rsync nfs-utils bc nasm mc

genfstab -p /mnt /mnt/etc/fstab

arch_chroot "sed -i 's/modconf block/modconf block lvm2/' /etc/mkinitcpio.conf"

arch_chroot "echo "root:$RPASS" | chpasswd" #
arch_chroot "ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime" #
arch_chroot "hwclock --systohc --utc"
arch_chroot "echo desktop > /etc/hostname"
arch_chroot "echo 'KEYMAP=br-abnt2' > /etc/vconsole.conf"

arch_chroot "sed -i '/pt_BR/s/^#//' /etc/locale.gen"

arch_chroot "locale-gen"
arch_chroot "useradd $USER -s /bin/bash -G wheel -m"
arch_chroot "echo "$USER:$PASS" | chpasswd" #
arch_chroot "sed -i '/%wheel ALL=(ALL) ALL/s/# %/%/' /etc/sudoers"

arch_chroot "echo '' >> /etc/pacman.conf"
arch_chroot "echo '[multilib]' >> /etc/pacman.conf"
arch_chroot "echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf"
arch_chroot "echo '' >> /etc/pacman.conf"
arch_chroot "echo '[archlinuxfr]' >> /etc/pacman.conf"
arch_chroot "echo 'SigLevel = Never' >> /etc/pacman.conf"
arch_chroot "echo 'Server = http://repo.archlinux.fr/\$arch' >> /etc/pacman.conf"

arch_chroot "pacman -Sy --noconfirm grub os-prober yaourt dmidecode acpi acpid mlocate bash-completion pkgstats namcap tmux net-tools docker"
arch_chroot "systemctl enable dhcpcd"
arch_chroot "systemctl enable acpid"
arch_chroot "systemctl enable sshd"
arch_chroot "sed -i '/StrictHostKeyChecking/s/#//g' /etc/ssh/ssh_config"
arch_chroot "sed -i '/StrictHostKeyChecking/s/ask/no/g' /etc/ssh/ssh_config"
arch_chroot "sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config"
arch_chroot "systemctl enable rpcbind.service"
arch_chroot "systemctl enable nfs-client.target"
arch_chroot "systemctl enable docker.service"
arch_chroot "usermod -aG docker $USER"
# arch_chroot "grub-install /dev/sda"
arch_chroot "grub-install --target=i386-pc --recheck /dev/sda"

# arch_chroot "sed -i 's/quiet/root=\/dev\/vg_zone\/lv_archlinux/' /etc/default/grub"
# arch_chroot "sed -i 's/part_msdos/part_msdos lvm/' /etc/default/grub"

arch_chroot "mkinitcpio -p linux"
arch_chroot "grub-mkconfig -o /boot/grub/grub.cfg"

arch_chroot "exit"

#!/bin/bash

GUEST=ArchLinux
ISOPATH=/aux/ISOs

iso=$ISOPATH/archlinux-2017.01.01-dual.iso ; OSTYPE=ArchLinux_64
# iso=$ISOPATH/FreeBSD-10.1-STABLE-amd64-20150201-r278028-uefi-disc1.iso ; OSTYPE=FreeBSD_64
# iso=$ISOPATH/FreeBSD-10.1-RC3-amd64-dvd1.iso ; OSTYPE=FreeBSD_64
# iso=$ISOPATH/FreeBSD-11.0-CURRENT-amd64-20150201-r278031-disc1.iso ; OSTYPE=FreeBSD_64
# iso=$ISOPATH/winxp_sp3_lite.iso ; OSTYPE=WindowsXP
# iso=$ISOPATH/windows8.1_x64/en_windows_8_1_pro_vl_x64_dvd_2971948.iso ; OSTYPE=Windows81_64

CPUS=1
RAM=1024
VIDEO=16
MONITORES=1

DISKS=1
HDSIZE=12000
HDPATH=$HOME/VirtualBoxVMs/
HDNAME=disk

NIC=enp3s0 #re0
MAC=0000000000c1
VRDE=3398

## CRIAR VM
vboxmanage createvm --name $GUEST --ostype $OSTYPE --register

vboxmanage modifyvm $GUEST --cpus $CPUS --memory $RAM --vram $VIDEO #--monitorcount $MONITORES
vboxmanage modifyvm $GUEST --acpi on --ioapic on --pae on #--accelerate3d on --accelerate2dvideo on
vboxmanage modifyvm $GUEST --usb on #--usbehci on
vboxmanage modifyvm $GUEST --clipboard bidirectional
# vboxmanage modifyvm $GUEST --chipset ich9 --pciattach 02:00.0@01:01.0 #(IOMMU)

## INTERFACES SATA
i=$DISKS
vboxmanage storagectl $GUEST --name sata --add sata #--portcount $i
for i in `seq 0 $(($i-1))`
do
vboxmanage createhd --filename $HDPATH/$GUEST/$HDNAME$i.vdi --size $HDSIZE --format vdi
vboxmanage storageattach $GUEST --storagectl sata --port $i --type hdd --medium $HDPATH/$GUEST/$HDNAME$i.vdi --mtype normal
done

## INTERFACES IDE
vboxmanage storagectl $GUEST --name ide --add ide #--portcount 1
vboxmanage storageattach $GUEST --storagectl ide --port 0 --device 0 --type dvddrive --medium $iso

## BOOT ORDER
vboxmanage modifyvm $GUEST --boot1 dvd --boot2 disk --boot3 none --boot4 none

## INTERFACES DE REDE
vboxmanage modifyvm $GUEST --nic1 bridged --bridgeadapter1 $NIC --macaddress1 $MAC --cableconnected1 on --nicpromisc1 deny

## SERVIDOR REMOTO
#vboxmanage modifyvm $GUEST --vrde on --vrdeport $VRDE --vrdeauthtype null --vrdemulticon on


## USBs
# vboxmanage usbfilter add 0 --target $GUEST --active yes --name "USB PnP Sound Device [0100]" --vendorid "0D8C" --productid "013C" --revision "0100" --product "USB PnP Sound Device"

# vboxmanage usbfilter add 1 --target $GUEST --active yes --name "IMPRESSORA" --vendorid "03F0" --productid "5817" --revision "0100" --manufacturer "Hewlett-Packard" --product "HP LaserJet M1319f MFP"

# vboxmanage usbfilter add 2 --target $GUEST --active yes --name "Kingston 4G" --vendorid "0930" --productid 6544 --revision "0100" --manufacturer "Kingston" --product "DT 101 G2"
######################################################

# vboxmanage usbfilter modify 1 --target ArchLinux --active no
# vboxmanage usbfilter remove 1 --target ArchLinux
# for i in {0..2} ; do (vboxmanage usbfilter remove $i --target ArchLinux); done

## OPCOES
# VBoxManage modifyhd /aux/VirtualBoxVMx/ArchLinux/hdd0.vdi --resize 16000
# vboxmanage modifyvm FreeBSD --boot1 disk --boot2 dvd

## TELEPORTE
# vboxmanage modifyvm ArchLinux --teleporter on --teleporterport 9999 --teleporterpassword aamu02
# vboxmanage controlvm ArchLinux teleport --host 191.96.255.100 --port 9999 --password 9999

######################################################
################## ADMINISTRAR VMs ###################
######################################################

## START & STOP VM
# vboxmanage startvm ArchLinux
# vboxmanage startvm ArchLinux --type headless
# vboxheadless -s ArchLinux &
#
# vboxmanage controlvm ArchLinux clipboard bidirectional
#				
# vboxmanage controlvm ArchLinux poweroff

## LISTAR VM
# vboxmanage list runningvms
# vboxmanage list vms
#
# vboxmanage showvminfo ArchLinux | grep State

## IMPORTAR & EXPORTAR
# vboxmanage import ArchLinux.ova
# vboxmanage export ArchLinux --output ArchLinux.ova

## DELETAR VM
# vboxmanage unregistervm ArchLinux --delete

## MODO SDL
# vboxsdl -vm FreeBSD
# vboxsdl -vm FreeBSD --fullscreen
# vboxsdl -vm FreeBSD --hostkey 306 64
# vboxsdl -vm FreeBSD --hostkey 306 64 --memory 512

## INFORMACOES
# vboxmanage list ostypes
# vboxmanage list systemproperties
# vboxmanage list hostinfo
# vboxmanage list extpacks
# vboxmanage -v

## MONTAR USB
# vboxmanage list usbhost
# vboxmanage controlvm ArchLinux usbattach UUID
######################################################

## RDESKTOP
# rdesktop-vrdp -a 16 -N localhost:3389
######################################################

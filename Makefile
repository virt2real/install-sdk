#########################################################
# Copyright (C) 2013 Virt2real (http://www.virt2real.ru)

export DEVDIR=${shell pwd}
export PLATFORM=dm365
export DEVICE=dm365-virt2real
MOUNTPOINT=`pwd`/images

V=@
ECHO=$(V)echo -e
OUTPUT=> /dev/null

#########################################################
# global SDK settings

#CROSSCOMPILE=/opt/codesourcery/arm-2010q1/bin/arm-none-linux-gnueabi-
CROSSCOMPILE=$(DEVDIR)/fs/output/host/usr/bin/arm-none-linux-gnueabi-
SDNAME=/dev/sdd

#########################################################

help:

	$(ECHO) ""
	$(ECHO) "\033[1;34mVirt2real Software Development Kit\033[0m"
	$(ECHO) ""
	$(ECHO) "\033[1mtargets available:\033[0m"
	$(ECHO) ""
	$(ECHO) "   getsdk		- download full SDK (kernel, DVSDK, Buildroot, adminka)"
	$(ECHO) "   getkernel		- download kernel"
	$(ECHO) "   getdvsdk		- download DVSDK"
	$(ECHO) "   getfs		- download file system"
	$(ECHO) "   getadminka		- download admin panel"
	$(ECHO) ""
	$(ECHO) "   build		- build all"
	$(ECHO) ""
	$(ECHO) "   clean		- clean all"
	$(ECHO) ""
	$(ECHO) "   install		- install all"
	$(ECHO) ""
	$(ECHO) "   kernelconfig		- config kernel"
	$(ECHO) "   kerneldefconfig	- set default config for kernel"
	$(ECHO) "   kernelclean		- clean kernel"
	$(ECHO) "   kernelbuild		- build kernel"
	$(ECHO) "   kernelmodulesbuild	- build kernel modules"
	$(ECHO) ""
	$(ECHO) "   fsconfig		- config filesystem"
	$(ECHO) "   fsclean		- clean filesystem"
	$(ECHO) "   fsbuild		- build filesystem"
	$(ECHO) ""
	$(ECHO) "   dvsdkbuild		- build DVSDK"
	$(ECHO) "   dvsdkclean		- clean DVSDK"
	$(ECHO) "   dvsdkinstall		- install DVSDK"
	$(ECHO) ""
	$(ECHO) "\033[1mmake parameters:\033[0m"
	$(ECHO) ""
	$(ECHO) "   VERBOSE		- if 1 - output all commands (VERBOSE=1)"


#########################################################
# Common SDK

getsdk:: getkernel getdvsdk getfs getadminka

getkernel:
	$(ECHO) ""
	$(ECHO) "\033[1;34mDownload Virt2real kernel\033[0m"
	$(ECHO) ""
	$(V)git clone https://github.com/virt2real/linux-davinci kernel

getdvsdk:
	$(ECHO) ""
	$(ECHO) "\033[1;34mDownload Virt2real DVSDK\033[0m"
	$(ECHO) ""
	$(V)git clone https://github.com/virt2real/DVSDK.git dvsdk
	

getfs:
	$(ECHO) ""
	$(ECHO) "\033[1;34mDownload Virt2real file system\033[0m"
	$(ECHO) ""
	$(V)git clone https://github.com/virt2real/dm36x-buildroot.git fs
	
getadminka:
	$(ECHO) ""
	$(ECHO) "\033[1;34mDownload Virt2real admin panel\033[0m"
	$(ECHO) ""
	$(V)git clone https://github.com/virt2real/admin_panel.git adminka
	
getuboot:
	$(ECHO) ""
	$(ECHO) "\033[1;34mDownload Virt2real U-Boot\033[0m"
	$(ECHO) ""
	$(V)git clone https://github.com/virt2real/v2r_uboot.git uboot
	


###########################################################


#########################################################
# kernel

kernelconfig:
	$(ECHO) ""
	$(ECHO) "\033[1;34mLinux Kernel Config for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(ECHO) "Board : \033[32m$(DEVICE)\033[0m"
	$(ECHO) ""
	
	$(V)make --directory=kernel ARCH=arm menuconfig

kerneldefconfig:
	$(ECHO) ""
	$(ECHO) "\033[1;34mLinux Kernel default config for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(ECHO) "Board : \033[32m$(DEVICE)\033[0m"
	$(ECHO) ""
	$(V)make --directory=kernel ARCH=arm distclean
	$(V)make --directory=kernel ARCH=arm davinci_v2r_defconfig

kernelclean:
	$(ECHO) ""
	$(ECHO) "\033[1;34mLinux Kernel clean for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(ECHO) "Board : \033[32m$(DEVICE)\033[0m"
	$(ECHO) ""
	$(V)make --directory=kernel ARCH=arm clean

kernelbuild:
	$(ECHO) ""
	$(ECHO) "\033[1;34mLinux Kernel Build for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(ECHO) "Board : \033[32m$(DEVICE)\033[0m"
	$(ECHO) ""
	$(V)make --directory=kernel -j4 ARCH=arm CROSS_COMPILE=$(CROSSCOMPILE) CONFIG_DEBUG_SECTION_MISMATCH=y uImage

kernelmodulesbuild:
	$(ECHO) ""
	$(ECHO) "\033[1;34mLinux Kernel Modules Build for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(ECHO) "Board : \033[32m$(DEVICE)\033[0m"
	$(ECHO) ""
	$(V)make --directory=kernel ARCH=arm CROSS_COMPILE=$(CROSSCOMPILE) modules


#########################################################
# filesystem (Buildroot)

fsconfig:
	$(ECHO) ""
	$(ECHO) "\033[1;34mLinux Filesystem Config for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(ECHO) "Board : \033[32m$(DEVICE)\033[0m"
	$(ECHO) ""
	$(V)make --directory=fs menuconfig

fsclean:
	$(ECHO) ""
	$(ECHO) "\033[1;34mLinux Filesystem clean for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(ECHO) "Board : \033[32m$(DEVICE)\033[0m"
	$(ECHO) ""
	$(V)make --directory=fs clean

fsbuild:
	$(ECHO) ""
	$(ECHO) "\033[1;34mLinux Filesystem build for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(ECHO) "Board : \033[32m$(DEVICE)\033[0m"
	$(ECHO) ""
	$(V)make --directory=fs

#########################################################
# DVSDK

dvsdkbuild:
	$(ECHO) ""
	$(ECHO) "\033[1;34mDVSDK build for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(ECHO) "Board : \033[32m$(DEVICE)\033[0m"
	$(ECHO) ""
	$(V)make --directory=dvsdk CSTOOL_PREFIX=$(CROSSCOMPILE) LINUXKERNEL_INSTALL_DIR=$(DEVDIR)/kernel  cmem edma irq dm365mm

dvsdkclean:
	$(ECHO) ""
	$(ECHO) "\033[1;34mDVSDK clean for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(ECHO) "Board : \033[32m$(DEVICE)\033[0m"
	$(ECHO) ""
	$(V)make --directory=dvsdk cmem_clean edma_clean irq_clean dm365mm_clean

dvsdkinstall:
	$(ECHO) ""
	$(ECHO) "\033[1;34mDVSDK install for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(ECHO) "Board : \033[32m$(DEVICE)\033[0m"
	$(ECHO) ""
	$(V)make --directory=dvsdk cmem_install edma_install irq_install dm365mm_install

#########################################################
# U-Boot

ubootbuild:
	$(ECHO) ""
	$(ECHO) "\033[1;34mU-Boot build for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(ECHO) "Board : \033[32m$(DEVICE)\033[0m"
	$(ECHO) ""
	$(V)make --directory=uboot ARCH=arm CROSS_COMPILE=$(CROSSCOMPILE) distclean
	$(V)make --directory=uboot ARCH=arm CROSS_COMPILE=$(CROSSCOMPILE) davinci_dm365v2r_config
	$(V)make --directory=uboot CROSS_COMPILE=$(CROSSCOMPILE) CONFIG_SYS_TEXT_BASE="0x82000000" EXTRA_CPPFLAGS="-DCONFIG_SPLASH_ADDRESS="0x80800000" -DCONFIG_SPLASH_COMPOSITE=1"


#########################################################
# Clean all

clean:: kernelclean fsclean dvsdkclean

#########################################################
# Build all

build:: fsbuild kernelbuild dvsdkbuild ubootbuild


#########################################################
# Installer

install:
	$(ECHO) ""
	$(ECHO) "\033[1;34mMain installer for Virt2real\033[0m"
	$(ECHO) ""
	$(ECHO) "Board : \033[32m$(DEVICE)\033[0m"
	$(ECHO) ""
	
	$(ECHO) "\033[31mWARNING!!! Device $(SDNAME) will be erased! \033[0m"
	$(ECHO) ""

	$(ECHO) "\033[1mCreating the partitions on microSD...\033[0m"
	$(V)echo -e "1,5,0xC,*\n6,,L" | sfdisk $(SDNAME) -q -D -H255 -S63 $(OUTPUT)
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""
	
	$(ECHO) "\033[1mFormating boot partition...\033[0m"
	$(V)sudo mkfs.vfat -F 32 $(SDNAME)1 -n boot $(OUTPUT)
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""
	
	$(ECHO) "\033[1mFormating rootfs partition...\033[0m"
	$(V)sudo mkfs.ext3 $(SDNAME)2 -L rootfs $(OUTPUT)
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""
	
	$(ECHO) "\033[1mFlashing bootloader...\033[0m"	
	$(V)sudo uboot/tools/uflash/uflash -d $(SDNAME) -u dvsdk/psp/board_utilities/ccs/dm365/UBL_DM36x_SDMMC.bin -b uboot/u-boot.bin -e 0x82000000 -l 0x82000000 $(OUTPUT)
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""
	
	$(ECHO) "\033[1mMounting boot partition\033[0m"
	$(V)mkdir -p $(MOUNTPOINT)/boot
	$(V)sudo mount $(SDNAME)1 $(MOUNTPOINT)/boot
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""
	
	$(ECHO) "\033[1mMounting rootfs partition\033[0m"
	$(V)mkdir -p $(MOUNTPOINT)/rootfs
	$(V)sudo mount $(SDNAME)2 $(MOUNTPOINT)/rootfs
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""
	
	$(ECHO) "\033[1mCopying uImage\033[0m"
	$(V)cp kernel/arch/arm/boot/uImage $(MOUNTPOINT)/boot/ $(OUTPUT)
	$(V)cp addons/uEnv.txt $(MOUNTPOINT)/boot/ $(OUTPUT)
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""
	
	$(ECHO) "\033[1mCopying root filesystem\033[0m"
	$(V)tar xvf fs/output/images/rootfs.tar -C $(MOUNTPOINT)/rootfs $(OUTPUT)
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""
	
	$(ECHO) "\033[1mInstalling DVSDK\033[0m"
	$(V)make --directory=dvsdk cmem_install edma_install irq_install dm365mm_install
	$(V)cp -r dvsdk/install/dm365/* $(MOUNTPOINT)/rootfs/
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""
	
	$(ECHO) "\033[1mCopying add-ons\033[0m"
	$(V)cp addons/shadow $(MOUNTPOINT)/rootfs/etc/ $(OUTPUT)
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""
	
	$(ECHO) "\033[1mCopying admin panel\033[0m"
	$(V)cp adminka/www/* $(MOUNTPOINT)/rootfs/var/www/ $(OUTPUT)
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""
	
	$(ECHO) "\033[1mSyncing\033[0m"
	$(V)sync
	$(V)umount $(MOUNTPOINT)/boot
	$(V)umount $(MOUNTPOINT)/rootfs
	$(V)rmdir $(MOUNTPOINT)/boot
	$(V)rmdir $(MOUNTPOINT)/rootfs
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""
	
	$(ECHO) "   Default user: root"
	$(ECHO) "   Default password: root"
	$(ECHO) ""

	$(ECHO) "\033[1mNow you can unmount and eject SD card $(SDNAME)\033[0m"

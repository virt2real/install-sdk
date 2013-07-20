#########################################################
# Copyright (C) 2013 Virt2real (http://www.virt2real.ru)

#SD card device name, CHANGE THIS!!!
SDNAME=/dev/sdX



export DEVDIR=${shell pwd}
export PLATFORM=dm365
export DEVICE=dm365-virt2real
MOUNTPOINT=${shell pwd}/images

V=@
ECHO=$(V)echo -e
M_ECHO=echo -e
OUTPUT=> /dev/null
DATE=${shell date "+%d%m%y-%H%M%S"}
date=$(DATE)

#########################################################
# global SDK settings

CSPATH=$(DEVDIR)/codesourcery/arm-2012.03
CROSSCOMPILE=$(CSPATH)/bin/arm-none-linux-gnueabi-
KERNEL_NAME=3.9.0-rc6-virt2real+

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
	$(ECHO) "   defconfig		- default config all"
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

getsdk:: getcodesourcery getkernel getdvsdk getfs getadminka getuboot

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
	$(V)git clone https://github.com/virt2real/v2r_buildroot.git fs
	
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
	
getcodesourcery:
	$(ECHO) ""
	$(ECHO) "\033[1;34mDownload CodeSourcery for Virt2real\033[0m"
	$(ECHO) ""
	
	$(V)wget -P codesourcery http://sourcery.mentor.com/public/gnu_toolchain/arm-none-linux-gnueabi/arm-2012.03-57-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2
	$(V)tar xvjf codesourcery/* -C codesourcery


###########################################################


#########################################################
# kernel

kernelconfig:
	$(ECHO) ""
	$(ECHO) "\033[1;34mLinux Kernel Config for Virt2real SDK\033[0m"
	$(ECHO) ""
	
	$(V)make --directory=kernel ARCH=arm menuconfig

kerneldefconfig:
	$(ECHO) ""
	$(ECHO) "\033[1;34mLinux Kernel default config for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(V)make --directory=kernel ARCH=arm distclean
	$(V)make --directory=kernel ARCH=arm davinci_v2r_defconfig

kernelclean:
	$(ECHO) ""
	$(ECHO) "\033[1;34mLinux Kernel clean for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(V)make --directory=kernel ARCH=arm clean

kernelbuild:
	$(ECHO) ""
	$(ECHO) "\033[1;34mLinux Kernel Build for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(V)make --directory=kernel -j4 ARCH=arm CROSS_COMPILE=$(CROSSCOMPILE) CONFIG_DEBUG_SECTION_MISMATCH=y uImage

kernelmodulesbuild:
	$(ECHO) ""
	$(ECHO) "\033[1;34mLinux Kernel Modules Build for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(V)make --directory=kernel ARCH=arm CROSS_COMPILE=$(CROSSCOMPILE) modules


#########################################################
# filesystem (Buildroot)

fsdefconfig:
	$(ECHO) ""
	$(ECHO) "\033[1;34mLinux Filesystem default config for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(V)make --directory=fs ARCH=arm virt2real_v1_defconfig

fsconfig:
	$(ECHO) ""
	$(ECHO) "\033[1;34mLinux Filesystem Config for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(V)make --directory=fs ARCH=arm menuconfig

fsclean:
	$(ECHO) ""
	$(ECHO) "\033[1;34mLinux Filesystem clean for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(V)make --directory=fs ARCH=arm clean

fsbuild:
	$(ECHO) ""
	$(ECHO) "\033[1;34mLinux Filesystem build for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(V)make --directory=fs ARCH=arm CSPATH=$(CSPATH)

#########################################################
# DVSDK

dvsdkbuild:
	$(ECHO) ""
	$(ECHO) "\033[1;34mDVSDK build for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(V)make --directory=dvsdk CSTOOL_PREFIX=$(CROSSCOMPILE) LINUXKERNEL_INSTALL_DIR=$(DEVDIR)/kernel  cmem edma irq dm365mm

dvsdkclean:
	$(ECHO) ""
	$(ECHO) "\033[1;34mDVSDK clean for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(V)make --directory=dvsdk cmem_clean edma_clean irq_clean dm365mm_clean

dvsdkinstall:
	$(ECHO) ""
	$(ECHO) "\033[1;34mDVSDK install for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(V)make --directory=dvsdk LINUXKERNEL_INSTALL_DIR=$(DEVDIR)/kernel cmem_install edma_install irq_install dm365mm_install

#########################################################
# U-Boot

ubootbuild:
	$(ECHO) ""
	$(ECHO) "\033[1;34mU-Boot build for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(V)make --directory=uboot ARCH=arm CROSS_COMPILE=$(CROSSCOMPILE) distclean
	$(V)make --directory=uboot ARCH=arm CROSS_COMPILE=$(CROSSCOMPILE) davinci_dm365v2r_config
	$(V)make --directory=uboot ARCH=arm CROSS_COMPILE=$(CROSSCOMPILE) CONFIG_SYS_TEXT_BASE="0x82000000" EXTRA_CPPFLAGS="-DCONFIG_SPLASH_ADDRESS="0x80800000" -DCONFIG_SPLASH_COMPOSITE=1"

ubootdefconfig:
	$(ECHO) ""
	$(ECHO) "\033[1;34mU-Boot default config for Virt2real SDK\033[0m"
	$(ECHO) ""
        $(V)make --directory=uboot ARCH=arm CROSS_COMPILE=$(CROSSCOMPILE) davinci_dm365v2r_config

#########################################################
# defconfig all

defconfig:: kerneldefconfig fsdefconfig ubootdefconfig


#########################################################
# Clean all

clean:: kernelclean fsclean dvsdkclean

#########################################################
# Build all

build:: fsbuild kernelbuild kernelmodulesbuild dvsdkbuild ubootbuild



#########################################################
# Installer

#########################################################
# Instal kernel

install_intro:
	$(ECHO) ""
	$(ECHO) "\033[1;34mMain installer for Virt2real\033[0m"
	$(ECHO) ""
	
	$(ECHO) "\033[31mWARNING!!! Device $(SDNAME) will be erased! \033[0m"
	$(ECHO) ""

	$(V)read -p "Press Enter to continue or Ctrl-C to abort"


prepare_partitions:
	$(ECHO) ""
	$(V)if [ ! -b $(SDNAME) ] ; then $(M_ECHO) "\033[31mDevice $(SDNAME) not found, aborting\033[0m"; exit 1 ; else $(M_ECHO) "\033[32mDevice $(SDNAME) found!\033[0m"; fi
	$(ECHO) ""
	$(ECHO) "\033[1mCreating the partitions on microSD...\033[0m"
	$(V)echo -e "1,5,0xC,*\n6,,L" | sudo sfdisk $(SDNAME) -q -D -H255 -S63 $(OUTPUT)
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

install_bootloader:
	$(V)if [ ! -b $(SDNAME) ] ; then $(M_ECHO) "\033[31mDevice $(SDNAME) not found, aborting\033[0m" ; exit 1; else $(M_ECHO) "\033[32mDevice $(SDNAME) found!\033[0m"; fi
	$(ECHO) ""
	$(ECHO) "\033[1mFlashing bootloader...\033[0m"	
	$(V)sudo uboot/tools/uflash/uflash -d $(SDNAME) -u dvsdk/psp/board_utilities/ccs/dm365/UBL_DM36x_SDMMC.bin -b uboot/u-boot.bin -e 0x82000000 -l 0x82000000 $(OUTPUT)
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""

mount_partitions:
	$(V)if [ ! -b $(SDNAME) ] ; then $(M_ECHO) "\033[31mDevice $(SDNAME) not found, aborting\033[0m" ; $(M_ECHO) ""; exit 1; fi
	$(V)if [ ! -d $(MOUNTPOINT)/boot ] ; then $(M_ECHO) "\033[1mMounting boot partition\033[0m"; sudo mkdir -p $(MOUNTPOINT)/boot; sudo mount $(SDNAME)1 $(MOUNTPOINT)/boot; $(M_ECHO) "\033[32m   done\033[0m"; $(M_ECHO) ""; fi
	$(V)if [ ! -d $(MOUNTPOINT)/rootfs ] ; then $(M_ECHO) "\033[1mMounting rootfs partition\033[0m"; sudo mkdir -p $(MOUNTPOINT)/rootfs; sudo mount $(SDNAME)2 $(MOUNTPOINT)/rootfs; $(M_ECHO) "\033[32m   done\033[0m"; $(M_ECHO) ""; fi

umount_partitions:
	$(V)if [ -d $(MOUNTPOINT)/boot ] ; then $(M_ECHO) "\033[1mUmounting boot partition\033[0m"; umount $(MOUNTPOINT)/boot; rmdir $(MOUNTPOINT)/boot; fi
	$(V)if [ -d $(MOUNTPOINT)/rootfs ] ; then $(M_ECHO) "\033[1mUmounting rootfs partition\033[0m"; umount $(MOUNTPOINT)/rootfs; rmdir $(MOUNTPOINT)/rootfs; fi

install_kernel_fs:
	$(V)if [ ! -f kernel/arch/arm/boot/uImage ] ; then $(M_ECHO) "\033[31mFile uImage not found, aborting\033[0m"; exit 1; fi
	$(V)if [ ! -f addons/uEnv.txt ] ; then $(M_ECHO) "\033[31mFile uEnv.txt not found, aborting\033[0m"; exit 1; fi
	$(ECHO) ""
	$(ECHO) "\033[1mCopying uImage\033[0m"
	$(V)sudo cp kernel/arch/arm/boot/uImage $(MOUNTPOINT)/boot/ $(OUTPUT)
	$(V)sudo cp addons/uEnv.txt $(MOUNTPOINT)/boot/ $(OUTPUT)
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""

	$(V)if [ ! -f fs/output/images/rootfs.tar ]; then $(M_ECHO) "\033[31mFile rootfs.tar not found, aborting\033[0m"; exit 1; fi
	$(ECHO) "\033[1mCopying root filesystem\033[0m"
	$(V)sudo tar xvf fs/output/images/rootfs.tar -C $(MOUNTPOINT)/rootfs $(OUTPUT)
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""

install_dsp:
	$(ECHO) "\033[1mInstalling DSP modules\033[0m"
	$(V)sudo make --directory=dvsdk LINUXKERNEL_INSTALL_DIR=$(DEVDIR)/kernel cmem_install edma_install irq_install dm365mm_install $(OUTPUT)
	$(V)sudo cp -r $(DEVDIR)/dvsdk/install/dm365/* $(MOUNTPOINT)/rootfs/  $(OUTPUT)
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""

install_modules:
	$(ECHO) "\033[1mInstalling kernel modules\033[0m"
	$(V)sudo make --directory=kernel ARCH=arm modules_install INSTALL_MOD_PATH=$(MOUNTPOINT)/rootfs $(OUTPUT)
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""

install_addons:
	$(ECHO) "\033[1mCopying add-ons\033[0m"
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""

install_adminka:
	$(ECHO) "\033[1mCopying admin panel\033[0m"
	$(V)sudo cp adminka/www/* $(MOUNTPOINT)/rootfs/var/www/ $(OUTPUT)
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""

sync_partitions:
	$(ECHO) "\033[1mSyncing\033[0m"
	$(V)sudo sync  $(OUTPUT)
	$(ECHO) ""
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""

install:: install_intro umount_partitions prepare_partitions install_bootloader mount_partitions install_kernel_fs  install_modules install_dsp install_addons install_adminka sync_partitions umount_partitions

	$(ECHO) "   Default user: root"
	$(ECHO) "   Default password: root"
	$(ECHO) ""

	$(ECHO) "\033[1mNow you can unmount and eject SD card $(SDNAME)\033[0m"


save_tarball:: mount_partitions maketarball umount_partitions

maketarball:
	$(ECHO) "Making boot and rootfs tarball"
	$(V)tar cvf sdcard-$(DATE).tar -C images ./ $(OUTPUT) && $(M_ECHO) "Created file sdcard-$(DATE).tar"
	$(ECHO) ""
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""

write_tarball:: check_file install_intro umount_partitions prepare_partitions install_bootloader mount_partitions writetarball sync_partitions umount_partitions

check_file:
	$(V)if [ ! -f $(FILENAME) ] ; then $(M_ECHO) "\033[31mFile $(FILENAME) not found, aborting\033[0m"; exit 1; fi	

writetarball:
	$(ECHO) "Writing boot and rootfs tarball"
	$(V)tar xvf $(FILENAME) -C $(MOUNTPOINT) $(OUTPUT)
	$(ECHO) ""
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""

make_image: umount_partitions mkimage

mkimage:
	$(ECHO) "Dumping $(SDNAME) image"
	$(ECHO) ""
	$(V)dd if=$(SDNAME) of=sdcard-$(date).img bs=1M
	tar czvf sdcard-$(date).img.tar.gz sdcard-$(date).img
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""

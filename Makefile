#########################################################
# Copyright (C) 2014 Virt2real (http://www.virt2real.ru)
#
#SD card default name, DONT CHANGE THIS!!!
SDDEFNAME=/dev/sdX

#SD card device name, CHANGE THIS!!!
#for example, SDNAME=/dev/sdc
SDNAME=/dev/sdX

# if your cardreader device partitions looks like "mmcblk0p1" - set PARTITIONPREFIX=p
# else if partitions looks like sdc1 - set PARTITIONPREFIX=   (empty)
PARTITIONPREFIX=


export DEVDIR=${shell pwd}
export PLATFORM=dm365
export DEVICE=dm365-virt2real
MOUNTPOINT=${shell pwd}/images
DOWNLOADDIR=download
WGET=wget

ifndef VERBOSE
    V=@
else
    V := $(shell if [ $(VERBOSE) = 1 ] ; then  echo "" ; fi )
endif

ECHO=$(V)echo -e
M_ECHO=echo -e
OUTPUT=> /dev/null
DATE=${shell date "+%d%m%y-%H%M%S"}
date=$(DATE)
OK=0

BOOTDIR:=${shell mount | grep $(SDNAME)$(PARTITIONPREFIX)1 | awk 'BEGIN { } { print $$3 }'}
ROOTFSDIR:=${shell mount | grep $(SDNAME)$(PARTITIONPREFIX)2 | awk 'BEGIN { } { print $$3 }'}

#########################################################
# global SDK settings

CSPATH=$(DEVDIR)/codesourcery/arm-2013.05
CSFILE=arm-2013.05-24-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2

# crosscompiler for all but no other two
CROSSCOMPILE=$(CSPATH)/bin/arm-none-linux-gnueabi-


# kernel full version info
export KERNEL_NAME=3.9.0-rc6-virt2real+


# GitHub prefix
ifdef TEAM
    GITHUB_V2R=git@github.com:virt2real
else
    GITHUB_V2R=https://github.com/virt2real
endif

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
	$(ECHO) "   TEAM		- if is set - clone by ssh (TEAM=1)"
	$(ECHO) ""


#########################################################
# Common SDK

getsdk:: getcodesourcery getkernel getdvsdk getfs getadminka getuboot getnandflasher

		$(ECHO) ""
		$(ECHO) "\033[1;34mVirt2real SDK is ready to rock'n'roll!\033[0m"
		$(ECHO) ""

getkernel:
	$(V)if [ -d kernel ] ; \
	then \
		$(M_ECHO) "\033[32mKernel found, skipping\033[0m" ; \
		$(M_ECHO) ""; \
	else \
		$(M_ECHO) "" ; \
		$(M_ECHO) "\033[1;34mDownload Virt2real kernel\033[0m" ;\
		$(M_ECHO) "" ;\
		git clone $(GITHUB_V2R)/linux-davinci kernel ; \
	fi

getdvsdk:
	$(V)if [ -d dvsdk ] ; \
	then \
		$(M_ECHO) "\033[32mDVSDK found, skipping\033[0m" ; \
		$(M_ECHO) ""; \
	else \
		$(M_ECHO) "" ; \
		$(M_ECHO) "\033[1;34mDownload DVSDK\033[0m" ;\
		$(M_ECHO) "" ;\
		git clone $(GITHUB_V2R)/DVSDK.git dvsdk ; \
	fi

getfs:
	$(V)if [ -d fs ] ; \
	then \
		$(M_ECHO) "\033[32mFilesystem found, skipping\033[0m" ; \
		$(M_ECHO) ""; \
	else \
		$(M_ECHO) "" ; \
		$(M_ECHO) "\033[1;34mDownload Virt2real filesystem\033[0m" ;\
		$(M_ECHO) "" ;\
		git clone $(GITHUB_V2R)/v2r_buildroot.git fs ; \
	fi

getadminka:
	$(V)if [ -d adminka ] ; \
	then \
		$(M_ECHO) "\033[32mAdmin panel found, skipping\033[0m" ; \
		$(M_ECHO) ""; \
	else \
		$(M_ECHO) "" ; \
		$(M_ECHO) "\033[1;34mDownload Virt2real admin panel\033[0m" ;\
		$(M_ECHO) "" ;\
		git clone $(GITHUB_V2R)/admin_panel.git adminka ; \
	fi

getuboot:
	$(V)if [ -d uboot ] ; \
	then \
		$(M_ECHO) "\033[32mU-boot found, skipping\033[0m" ; \
		$(M_ECHO) ""; \
	else \
		$(M_ECHO) "" ; \
		$(M_ECHO) "\033[1;34mDownload Virt2real U-boot\033[0m" ;\
		$(M_ECHO) "" ;\
		#git clone $(GITHUB_V2R)/v2r_uboot.git uboot ; \
		git clone $(GITHUB_V2R)/u-boot.git uboot ; \
		cd uboot ; \
		git checkout v2011.03-virt2real.20140207 ; \
		cd .. ; \
	fi

getcodesourcery:
	$(V)if [ -d $(CSPATH) ] ; \
	then \
		$(M_ECHO) ""; \
		$(M_ECHO) "\033[32mCodeSourcery found, skipping\033[0m" ; \
		$(M_ECHO) ""; \
	else \
		$(M_ECHO) "" ; \
		$(M_ECHO) "\033[1;34mDownload CodeSourcery\033[0m" ;\
		$(M_ECHO) "" ;\
		if [ -f $(DOWNLOADDIR)/$(CSFILE) ] ; then rm $(DOWNLOADDIR)/$(CSFILE) $(OUTPUT); fi ; \
		$(WGET) -P $(DOWNLOADDIR) http://sourcery.mentor.com/public/gnu_toolchain/arm-none-linux-gnueabi/$(CSFILE) ; \
		$(M_ECHO) "" ; \
		$(M_ECHO) "\033[32m   done\033[0m" ; \
		mkdir codesourcery $(OUTPUT); \
		$(M_ECHO) "" ; \
		$(M_ECHO) "\033[1;34mUnpacking CodeSourcery\033[0m" ;\
		$(M_ECHO) "" ; \
		tar xvf $(DOWNLOADDIR)/$(CSFILE) -C codesourcery $(OUTPUT) ; \
		$(M_ECHO) "\033[32m   done\033[0m" ; \
		$(M_ECHO) "" ; \
	fi


getnandflasher:
	$(V)if [ -d nand_flasher ] ; \
	then \
		$(M_ECHO) "\033[32mNANDflasher found, skipping\033[0m" ; \
		$(M_ECHO) ""; \
	else \
		$(M_ECHO) "" ; \
		$(M_ECHO) "\033[1;34mDownload NAND flasher\033[0m" ;\
		$(M_ECHO) "" ;\
		git clone $(GITHUB_V2R)/nand_flasher.git nand_flasher ; \
	fi


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


kernelheaders:
	$(ECHO) ""
	$(ECHO) "\033[1;34mLinux Kernel Headers install for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(V)make --directory=kernel ARCH=arm CROSS_COMPILE=$(CROSSCOMPILE) INSTALL_HDR_PATH=$(shell pwd)/kernel-headers headers_install 

kernelupdate:
	$(ECHO) ""
	$(ECHO) "\033[1;34mLinux Kernel Update for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(V)cd kernel
	$(V)git pull
	$(ECHO) "\n\033[1mkernel update done\033[0m"

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
	$(ECHO) ""
	$(ECHO) "\n\033[1mFilesystem build done\033[0m"
	$(ECHO) ""

fsupdate:
	$(ECHO) ""
	$(ECHO) "\033[1;34mLinux Filesystem Update for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(V)cd fs
	$(V)git pull
	$(ECHO) "\n\033[1mfilesystem update done\033[0m"

#########################################################
# DVSDK

dvsdkbuild:
	$(ECHO) ""
	$(ECHO) "\033[1;34mDVSDK build for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(V)make --directory=dvsdk CSTOOL_PREFIX=$(CROSSCOMPILE) LINUXKERNEL_INSTALL_DIR=$(DEVDIR)/kernel  cmem edma irq dm365mm dmai
	$(ECHO) "\n\033[1mDVSDK build  done\033[0m"

dvsdkclean:
	$(ECHO) ""
	$(ECHO) "\033[1;34mDVSDK clean for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(V)make --directory=dvsdk cmem_clean edma_clean irq_clean dm365mm_clean dmai_clean
	$(ECHO) "\n\033[1mDVSDK clean  done\033[0m"

dvsdkinstall:
	$(ECHO) ""
	$(ECHO) "\033[1;34mDVSDK install for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(V)make --directory=dvsdk LINUXKERNEL_INSTALL_DIR=$(DEVDIR)/kernel cmem_install edma_install irq_install dm365mm_install
	$(ECHO) "\n\033[1mDVSDK install  done\033[0m"

dvsdkupdate:
	$(ECHO) ""
	$(ECHO) "\033[1;34mDVSDK Update for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(V)cd dvsdk
	$(V)git pull
	$(ECHO) "\n\033[1mdvsdk update done\033[0m"


#########################################################
# U-Boot

ubootbuild:
	$(ECHO) ""
	$(ECHO) "\033[1;34mU-Boot build for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(V)make --directory=uboot ARCH=arm CROSS_COMPILE=$(CROSSCOMPILE) distclean
	$(V)make --directory=uboot ARCH=arm CROSS_COMPILE=$(CROSSCOMPILE) davinci_dm365v2r_config
	$(V)make --directory=uboot ARCH=arm CROSS_COMPILE=$(CROSSCOMPILE) CONFIG_SYS_TEXT_BASE="0x82000000" EXTRA_CPPFLAGS="-DCONFIG_SPLASH_ADDRESS="0x80800000" -DCONFIG_SPLASH_COMPOSITE=1"
	$(ECHO) "\n\033[1mU-Boot build  done\033[0m"

ubootdefconfig:
	$(ECHO) ""
	$(ECHO) "\033[1;34mU-Boot default config for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(V)make --directory=uboot ARCH=arm CROSS_COMPILE=$(CROSSCOMPILE) davinci_dm365v2r_config

ubootclean:
	$(ECHO) ""
	$(ECHO) "\033[1;34mU-Boot clean for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(V)make --directory=uboot ARCH=arm CROSS_COMPILE=$(CROSSCOMPILE) clean

ubootupdate:
	$(ECHO) ""
	$(ECHO) "\033[1;34mU-Boot Update for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(V)cd uboot
	$(V)git pull
	$(ECHO) "\n\033[1muboot update done\033[0m"


#########################################################
# adminka

adminkaupdate:
	$(ECHO) ""
	$(ECHO) "\033[1;34mAdminka Update for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(V)cd adminka
	$(V)git pull
	$(ECHO) "\n\033[1madminka update done\033[0m"


#########################################################
# defconfig all

defconfig:: kerneldefconfig fsdefconfig ubootdefconfig


#########################################################
# Clean all

clean:: kernelclean fsclean dvsdkclean ubootclean

#########################################################
# Build all

build:: ubootbuild kernelbuild kernelmodulesbuild dvsdkbuild fsbuild



#########################################################
# Installer

install_intro:
	$(ECHO) ""

	$(V)if [ ! $(SDNAME) ] ; then $(M_ECHO) "\033[31mEmpty SD card name, please set SDNAME variable\033[0m" ; $(M_ECHO) ""; exit 1; fi
	$(V)if [ "$(SDNAME)" = "$(SDDEFNAME)" ] ; then $(M_ECHO) "\033[31mSD card name is default, please set SDNAME variable\033[0m" ; $(M_ECHO) ""; exit 1; fi


	$(V)if [ ! "$(OK)" = "1" ] ; then \
	$(M_ECHO) "" ; \
	$(M_ECHO) "\033[1;34mMain installer for Virt2real\033[0m" ; \
	$(M_ECHO) "" ; \
	$(M_ECHO) "\033[31mWARNING!!! Device \033[1m$(SDNAME)\033[0m \033[31mwill be erased! \033[0m" ; \
	$(M_ECHO) "" ; \
	read -p "Press Enter to continue or Ctrl-C to abort" ; \
	fi
	$(ECHO) ""
	$(ECHO) "Ok, next step"
	$(ECHO) ""
	$(V)OK=1


prepare_partitions:: install_intro
	$(ECHO) ""

	$(V)if [ ! $(SDNAME) ] ; then $(M_ECHO) "\033[31mEmpty SD card name, please set SDNAME variable\033[0m" ; $(M_ECHO) ""; exit 1; fi
	$(V)if [ "$(SDNAME)" = "$(SDDEFNAME)" ] ; then $(M_ECHO) "\033[31mSD card name is default, please set SDNAME variable\033[0m" ; $(M_ECHO) ""; exit 1; fi

	$(V)if [ ! -b $(SDNAME) ] ; then $(M_ECHO) "\033[31mDevice $(SDNAME) not found, aborting\033[0m"; exit 1 ; else $(M_ECHO) ""; $(M_ECHO) "\033[32mDevice $(SDNAME) found!\033[0m"; fi
	$(ECHO) ""
	$(ECHO) "\033[1mCreating the partitions on microSD...\033[0m"

	# full SD size
	#	$(V)echo -e "1,5,0xC,*\n6,,L" | sudo sfdisk $(SDNAME) -q -D -H255 -S63 $(OUTPUT)

	# limited SD size (about 1Gb)
	$(V)echo -e "1,5,0xC,*\n6,130,L" | sudo sfdisk $(SDNAME) -q -D -H255 -S63 --force $(OUTPUT)


	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""

	sleep 5

	$(ECHO) "\033[1mFormating boot partition...\033[0m"
	$(V)sudo mkfs.vfat -F 32 $(SDNAME)$(PARTITIONPREFIX)1 -n boot $(OUTPUT)
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""

	$(ECHO) "\033[1mFormating rootfs partition...\033[0m"
	$(V)sudo mkfs.ext3 $(SDNAME)$(PARTITIONPREFIX)2 -L rootfs $(OUTPUT)
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""

install_bootloader:: install_intro getuboot getdvsdk
	$(ECHO) ""

	$(V)if [ ! $(SDNAME) ] ; then $(M_ECHO) "\033[31mEmpty SD card name, please set SDNAME variable\033[0m" ; $(M_ECHO) ""; exit 1; fi
	$(V)if [ "$(SDNAME)" = "$(SDDEFNAME)" ] ; then $(M_ECHO) "\033[31mSD card name is default, please set SDNAME variable\033[0m" ; $(M_ECHO) ""; exit 1; fi


	$(V)if [ ! -b $(SDNAME) ] ; then $(M_ECHO) ""; $(M_ECHO) "\033[31mDevice $(SDNAME) not found, aborting\033[0m" ; exit 1; else $(M_ECHO) ""; $(M_ECHO) "\033[32mDevice $(SDNAME) found!\033[0m"; $(M_ECHO) "";  fi
	$(V)if [ ! -f uboot/tools/uflash/uflash ] ; then $(M_ECHO) ""; $(M_ECHO) "\033[31muflash not found, aborting. Please, make getuboot to download this\033[0m"; $(M_ECHO) ""; exit 1; fi
	$(V)if [ ! -f dvsdk/psp/board_utilities/serial_flash/dm365/UBL_DM36x_SDMMC.bin ] ; then $(M_ECHO) ""; $(M_ECHO) "\033[31muflash not found, aborting. Please, make getdvsdk to download this\033[0m"; $(M_ECHO) ""; exit 1; fi
	$(ECHO) ""
	$(ECHO) "\033[1mFlashing bootloader...\033[0m"
	$(V)sudo uboot/tools/uflash/uflash -d $(SDNAME) -u dvsdk/psp/board_utilities/serial_flash/dm365/UBL_DM36x_SDMMC.bin -b uboot/u-boot.bin -e 0x82000000 -l 0x82000000 $(OUTPUT)
	$(ECHO) "";
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""

install_kernel_fs:
	$(V)if [ ! -f kernel/arch/arm/boot/uImage ] ; then $(M_ECHO) ""; $(M_ECHO) "\033[31mFile uImage not found, aborting\033[0m"; exit 1; fi
	$(V)if [ ! -f addons/uEnv.txt ] ; then $(M_ECHO) ""; $(M_ECHO) "\033[31mFile uEnv.txt not found, aborting\033[0m"; exit 1; fi
	$(ECHO) ""
	$(ECHO) "\033[1mCopying uImage\033[0m"
	$(V)sudo cp kernel/arch/arm/boot/uImage $(MOUNTPOINT)/boot/ $(OUTPUT)
	$(V)sudo cp addons/uEnv.txt $(MOUNTPOINT)/boot/ $(OUTPUT)
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""

	$(V)if [ ! -f fs/output/images/rootfs.tar ]; then $(M_ECHO) ""; $(M_ECHO) "\033[31mFile rootfs.tar not found, aborting\033[0m"; exit 1; fi
	$(ECHO) "\033[1mCopying root filesystem\033[0m"
	$(V)sudo tar xvf fs/output/images/rootfs.tar -C $(MOUNTPOINT)/rootfs $(OUTPUT)
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""

install_dsp:
	$(ECHO) "\033[1mInstalling DSP modules\033[0m"
	$(V)sudo DEVDIR=$(DEVDIR) make --directory=dvsdk LINUXKERNEL_INSTALL_DIR=$(DEVDIR)/kernel cmem_install edma_install irq_install dm365mm_install $(OUTPUT)
	$(V)sudo cp -r $(DEVDIR)/dvsdk/install/dm365/* $(MOUNTPOINT)/rootfs/  $(OUTPUT)

	$(V)echo "kernel/drivers/dsp/cmemk.ko:" | sudo tee -a $(MOUNTPOINT)/rootfs/lib/modules/$(KERNEL_NAME)/modules.dep
	$(V)echo "kernel/drivers/dsp/dm365mmap.ko:" | sudo tee -a $(MOUNTPOINT)/rootfs/lib/modules/$(KERNEL_NAME)/modules.dep
	$(V)echo "kernel/drivers/dsp/irqk.ko:" | sudo tee -a $(MOUNTPOINT)/rootfs/lib/modules/$(KERNEL_NAME)/modules.dep
	$(V)echo "kernel/drivers/dsp/edmak.ko:" | sudo tee -a $(MOUNTPOINT)/rootfs/lib/modules/$(KERNEL_NAME)/modules.dep

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
	$(V)sudo cp -r adminka/www/* $(MOUNTPOINT)/rootfs/var/www/ $(OUTPUT)
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""

install:: install_intro umount_partitions prepare_partitions install_bootloader mount_partitions install_kernel_fs  install_modules install_dsp install_addons install_adminka sync_partitions umount_partitions

	$(ECHO) "   Default user: root"
	$(ECHO) "   Default password: root"
	$(ECHO) ""

	$(ECHO) "\033[1mNow you can unmount and eject SD card $(SDNAME)\033[0m"

#########################################################
# Partitions

mount_partitions:
	$(ECHO) ""

	$(V)if [ ! $(SDNAME) ] ; then $(M_ECHO) "\033[31mEmpty SD card name, please set SDNAME variable\033[0m" ; $(M_ECHO) ""; exit 1; fi
	$(V)if [ "$(SDNAME)" = "$(SDDEFNAME)" ] ; then $(M_ECHO) "\033[31mSD card name is default, please set SDNAME variable\033[0m" ; $(M_ECHO) ""; exit 1; fi

	$(V)if [ ! -b $(SDNAME) ] ; then $(M_ECHO) "\033[31mDevice $(SDNAME) not found, aborting\033[0m" ; $(M_ECHO) ""; exit 1; fi
	$(V)if [ ! -d $(MOUNTPOINT)/boot ] ; then $(M_ECHO) "\033[1mMounting boot partition\033[0m"; sudo mkdir -p $(MOUNTPOINT)/boot; sudo mount $(SDNAME)$(PARTITIONPREFIX)1 $(MOUNTPOINT)/boot; $(M_ECHO) "" ; $(M_ECHO) "\033[32m   done\033[0m"; $(M_ECHO) ""; fi
	$(V)if [ ! -d $(MOUNTPOINT)/rootfs ] ; then $(M_ECHO) "\033[1mMounting rootfs partition\033[0m"; sudo mkdir -p $(MOUNTPOINT)/rootfs; sudo mount $(SDNAME)$(PARTITIONPREFIX)2 $(MOUNTPOINT)/rootfs; $(M_ECHO) "" ; $(M_ECHO) "\033[32m   done\033[0m"; $(M_ECHO) ""; fi

umount_partitions:

	$(ECHO) ""

	$(V)if [ ! $(SDNAME) ] ; then $(M_ECHO) "\033[31mEmpty SD card name, please set SDNAME variable\033[0m" ; $(M_ECHO) ""; exit 1; fi
	$(V)if [ "$(SDNAME)" = "$(SDDEFNAME)" ] ; then $(M_ECHO) "\033[31mSD card name is default, please set SDNAME variable\033[0m" ; $(M_ECHO) ""; exit 1; fi

	$(V)if [ $(BOOTDIR) ] ; then if [ -d $(BOOTDIR) ] ; then $(M_ECHO) "\033[1mUmounting boot partition\033[0m"; umount $(BOOTDIR);  $(M_ECHO) "" ; $(M_ECHO) "\033[32m   done\033[0m"; $(M_ECHO) ""; rmdir $(BOOTDIR); fi ; fi
	$(V)if [ $(ROOTFSDIR) ] ; then if [ -d $(ROOTFSDIR) ] ; then $(M_ECHO) "\033[1mUmounting rootfs partition\033[0m"; umount $(ROOTFSDIR);  $(M_ECHO) "" ; $(M_ECHO) "\033[32m   done\033[0m"; $(M_ECHO) ""; rmdir $(ROOTFSDIR); fi ; fi

sync_partitions:
	$(ECHO) ""
	$(ECHO) "\033[1mSyncing\033[0m"
	$(V)sudo sync  $(OUTPUT)
	$(ECHO) ""
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""


#########################################################
# NAND flasher
# based on http://processors.wiki.ti.com/index.php/SD_card_boot_and_flashing_tool_for_DM355_and_DM365
#

nandbuild:
	$(ECHO) ""
	$(ECHO) "\033[1;34mNAND flasher build for Virt2real SDK\033[0m"
	$(ECHO) ""
	export PATH=$(CSPATH)/bin:$(DEVDIR)/uboot/tools:$PATH
	$(V)make --directory=nand_flasher -j4 ARCH=arm CROSSCOMPILE=$(CROSSCOMPILE) all
	$(ECHO) "\n\033[1mNAND flasher build  done\033[0m"

nandclean:
	$(ECHO) ""
	$(ECHO) "\033[1;34mNAND flasher clean for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(V)make --directory=nand_flasher ARCH=arm CROSS_COMPILE=$(CROSSCOMPILE) clean

nandupdate:
	$(ECHO) ""
	$(ECHO) "\033[1;34mNAND flasher Update for Virt2real SDK\033[0m"
	$(ECHO) ""
	$(V)cd nand_flasher
	$(V)git pull
	$(ECHO) "\n\033[1mNAND flasher update done\033[0m"

nandformatcard:
	$(ECHO) ""
	$(V)if [ ! $(SDNAME) ] ; then $(M_ECHO) "\033[31mEmpty SD card name, please set SDNAME variable\033[0m" ; $(M_ECHO) ""; exit 1; fi
	$(V)if [ "$(SDNAME)" = "$(SDDEFNAME)" ] ; then $(M_ECHO) "\033[31mSD card name is default, please set SDNAME variable\033[0m" ; $(M_ECHO) ""; exit 1; fi
	$(V)if [ ! -b $(SDNAME) ] ; then $(M_ECHO) "\033[31mDevice $(SDNAME) not found, aborting\033[0m"; exit 1 ; else $(M_ECHO) ""; $(M_ECHO) "\033[32mDevice $(SDNAME) found!\033[0m"; fi

	$(V)$(M_ECHO) "\033[31mWARNING!!! Device \033[1m$(SDNAME)\033[0m \033[31mwill be erased! \033[0m"
	$(V)$(M_ECHO) ""
	$(V)read -p "Press Enter to continue or Ctrl-C to abort"

	$(ECHO) ""
	$(V)$(ECHO) "\033[1;34mFormatting SD card for NAND flasher\033[0m"
	$(V)$(ECHO) ""
	$(V)cd $(DEVDIR)/nand_flasher && ./dm3xx_sd_boot format $(SDNAME)
	$(V)sync
	$(ECHO) "\n\033[1mFormating SD card for NAND flasher done\033[0m"
	$(V)$(ECHO) ""

nandinstallcard:
	$(ECHO) ""
	$(V)if [ ! -d $(MOUNTPOINT)/boot ] ; then $(M_ECHO) "\033[1mMounting boot partition\033[0m"; sudo mkdir -p $(MOUNTPOINT)/boot; sudo mount $(SDNAME)$(PARTITIONPREFIX)1 $(MOUNTPOINT)/boot; $(M_ECHO) "" ; $(M_ECHO) "\033[32m   done\033[0m"; $(M_ECHO) ""; fi
	$(ECHO) ""
	$(V)$(ECHO) "\033[1;34mInstalling SD card for NAND flasher\033[0m"
	$(ECHO) ""

	$(V)cd $(DEVDIR)/nand_flasher && ./dm3xx_sd_boot data $(MOUNTPOINT)/boot/dm3xx.dat

	$(ECHO) ""
	$(V)$(M_ECHO) "\033[1mUmounting boot partition\033[0m"

	$(V)umount $(MOUNTPOINT)/boot
	$(V)rmdir $(MOUNTPOINT)/boot	

	$(ECHO) "\n\033[1mInstalling SD card for NAND flasher done\033[0m"
	$(V)$(ECHO) ""


#########################################################
# Tarballs and images

save_tarball:: mount_partitions maketarball umount_partitions

maketarball:
	$(ECHO) "Making boot and rootfs tarball"
	$(V)tar cvf sdcard-$(DATE).tar -C images ./ $(OUTPUT) && $(M_ECHO) "Created file sdcard-$(DATE).tar"
	$(ECHO) ""
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""

write_tarball:: check_file install_intro umount_partitions prepare_partitions install_bootloader mount_partitions

	$(ECHO) "Writing boot and rootfs tarball"
	$(V)tar xvf $(FILENAME) -C $(MOUNTPOINT) $(OUTPUT)
	$(ECHO) ""
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""

	sync_partitions umount_partitions

check_file:
	$(V)if [ ! -f $(FILENAME) ] ; then $(M_ECHO) ""; $(M_ECHO) "\033[31mFile $(FILENAME) not found, aborting\033[0m"; $(M_ECHO) ""; exit 1; fi

writetarball:
	$(ECHO) ""
	$(ECHO) "\033[1mWriting boot and rootfs tarball\033[0m"
	$(V)tar xvf $(FILENAME) -C $(MOUNTPOINT) $(OUTPUT)
	$(ECHO) ""
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""

save_image: umount_partitions mkimage

mkimage:
	$(ECHO) ""
	$(ECHO) "\033[1mDumping $(SDNAME) image\033[0m"
	$(ECHO) ""
	$(V)dd if=$(SDNAME) of=sdcard-$(date).img bs=1M
	tar czvf sdcard-$(date).img.tar.gz sdcard-$(date).img
	$(ECHO) "\033[32m   done\033[0m"
	$(ECHO) ""

download_current:
	$(V)if [ -f $(DOWNLOADDIR)/current.tar.gz ] ; then rm $(DOWNLOADDIR)/current.tar.gz $(OUTPUT); fi
	$(ECHO) ""
	$(ECHO) "\033[1;34mDownload current tarball\033[0m"
	$(ECHO) ""
	$(V)$(WGET) -P $(DOWNLOADDIR) http://files.virt2real.ru/firmware/virt2real-board/1.1/current.tar.gz
	$(ECHO) "\033[32m   done\033[0m"


#########################################################
# Updates

updateprefix:
	$(ECHO) "\n\033[1mUpdate Virt2real SDK components\033[0m"
	

update:: updateprefix adminkaupdate dvsdkupdate fsupdate kernelupdate ubootupdate nandupdate

.PHONY : clean

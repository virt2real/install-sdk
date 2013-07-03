#########################################################
# Copyright (C) 2013 Virt2real (http://www.virt2real.ru)

#########################################################
# global SDK settings

CROSSCOMPILE=/opt/codesourcery/arm-2010q1/bin/arm-none-linux-gnueabi-

#########################################################

export DEVDIR=${shell pwd}
export PLATFORM=dm365
export DEVICE=dm365-virt2real

export V=@
export ECHO=$(V)echo -e

help:

	$(ECHO) ""
	$(ECHO) "\033[1;34mVirt2real Software Development Kit\033[0m"
	$(ECHO) ""
	$(ECHO) "\033[1mtargets available:\033[0m"
	$(ECHO) ""
	$(ECHO) "   installsdk		- install full SDK (kernel, DVSDK, Buildroot, CodeSourcery"
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

installsdk:
	$(ECHO) ""
	$(ECHO) "\033[1;34mDownload and set up Virt2real SDK\033[0m"
	$(ECHO) ""
	$(ECHO) "Board : \033[32m$(DEVICE)\033[0m"
	$(ECHO) ""

	$(V)git clone https://github.com/virt2real/linux-davinci kernel
	$(V)git clone https://github.com/virt2real/DVSDK.git dvsdk
	$(V)git clone https://github.com/virt2real/dm36x-buildroot.git fs
	$(V)git clone https://github.com/virt2real/admin_panel.git adminka

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




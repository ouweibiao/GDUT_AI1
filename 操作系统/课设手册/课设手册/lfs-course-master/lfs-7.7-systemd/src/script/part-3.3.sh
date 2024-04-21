#
# Part III. Building the LFS System (3)
#

#
# Introduction
#

#
# 在这一部分，我们编译 Linux 内核。
#
# 0. 你应该以 root 用户登录宿主系统，如：
#    ssh root@192.168.56.102 # instead of your own IP address
# 1. 要进行 mount 操作：
#    sh ~/mount-and-populate.sh
# 2. 要进入 chrooted 环境：
#    sh ~/chroot2lfs2.sh
# 3. 本节我们用一个 .config 参考文件来编译，但是您应该了解如何
#    使用“make menuconfig”来配置内核。
#

#
# Chapter 8. Making the LFS System Bootable
#

# 8.1. Introduction

# 8.2. Creating the /etc/fstab File
# It has done at section 7.11.

# 8.3. Linux-3.19

# 8.3.1. Installation of the kernel

# Set an environment variable to tell the make program 
# that how many processors are available
#
export MAKEFLAGS='-j 4'
echo $MAKEFLAGS 1>&2
#-j 4
# 这里是 4 核，你的情况可能与此不同。

cd /sources
tar xJf linux-3.19.tar.xz
cd linux-3.19

# Prepare for compilation by running the following command:
make mrproper # This ensures that the kernel tree is absolutely clean.

#
# 以下是对 SCSI 总线驱动进行配置，要做到“应选尽选”。
# You can check the device on PCI bus to install driver
# lspci

# For SCSI Disk
# Linux Kernel Configuration
#    -> Device Drivers
#        -> SCSI device support
#            -> SCSI disk support

# For BusLogic
# Linux Kernel Configuration
#    -> Device Drivers
#        -> SCSI device support
#            -> SCSI low-level drivers
#                -> BusLogic SCSI support

# For LSI Logic
# Linux Kernel Configuration
#    -> Device Drivers 
#        -> Fusion MPT device support
#            -> Fusion MPT (base + ScsiHost) drivers 
#

#
# 以下是针对本次实验情况对内核进行的配置，应严格与其保持一致。
# Refer to LFS-BOOK
#
# General setup --->
#   [*] open by fhandle syscalls [CONFIG_FHANDLE]
#   [ ] Auditing support [CONFIG_AUDIT]
#   [*] Control Group support [CONFIG_CGROUPS]
# Processor type and features --->
#   [*] Enable seccomp to safely compute untrusted bytecode [CONFIG_SECCOMP]
# Networking support --->
#   Networking options --->
#     <*> The IPv6 protocol [CONFIG_IPV6]
# Device Drivers --->
#   Generic Driver Options --->
#     [ ] Support for uevent helper [CONFIG_UEVENT_HELPER]
#     [*] Maintain a devtmpfs filesystem to mount at /dev [CONFIG_DEVTMPFS]
#     [ ] Fallback user-helper invocation for firmware loading [CONFIG_FW_LOADER_USER_HELPER]
# Firmware Drivers --->
#   [*] Export DMI identification via sysfs to userspace [CONFIG_DMIID]
# File systems --->
#   [*] Inotify support for userspace [CONFIG_INOTIFY_USER]
#   <*> Kernel automounter version 4 support (also supports v3) [CONFIG_AUTOFS4_FS]
#   Pseudo filesystems --->
#     [*] Tmpfs POSIX Access Control Lists [CONFIG_TMPFS_POSIX_ACL]
#     [*] Tmpfs extended attributes [CONFIG_TMPFS_XATTR]
#

# deep-into-study
##ls /sources/linux-3.19/arch/x86/configs/x86_64_defconfig

# A good starting place for setting up the kernel configuration is 
# to run the following command:
##make defconfig # the config file was saved to .config
# This will set the base configuration to a good state that 
# takes your current system architecture into account.
# But we perfer to make menuconfig in this course.

##make menuconfig
# Default to save to /sources/linux-3.19/.config
# 用 ls -a 查看。

# 为节约时间，我们以一个 a sample of .config 文件为例直接进行编译，
# 但是您应该了解如何用“make menuconfig”来配置内核。
cp $LFS/material/lfs-course/lfs-7.7-systemd/src/config/sample/lfs_target_system/kernel/linux-3.19/.config4vmware_vm ./.config

make
#...
#Kernel: arch/x86/boot/bzImage is ready  (#1)

# deep-into-study
##ls -l System.map
#-rw-r--r-- 1 root root 3158273 Dec 28 09:51 System.map

make modules_install
#......
#DEPMOD  3.19.0

# Some files need to be copied to the /boot directory
cp -v arch/x86/boot/bzImage /boot/vmlinuz-3.19-lfs-7.7-systemd
cp -v System.map /boot/System.map-3.19
cp -v .config /boot/config-3.19

# Install the documentation for the Linux kernel:
install -d /usr/share/doc/linux-3.19
cp -r Documentation/* /usr/share/doc/linux-3.19

# If the kernel source tree is going to be retained, 
# run chown -R 0:0 on the linux-3.19 directory 
# to ensure all files are owned by user root
cd /sources
chown -R 0:0 linux-3.19

# 8.3.2. Configuring Linux Module Load Order
# Ignore it.


#
# Next
#

cd /
cat > /tf/prompt2enter-next-step.txt << "EOF"
 __       _______     _______.
|  |     |   ____|   /       |
|  |     |  |__     |   (----`
|  |     |   __|     \   \    
|  `----.|  |    .----)   |   
|_______||__|    |_______/    
                              
                              
                              
                              
                              
                              
                              
                              
 ----------------------------
| Please enter Part-3.4.     |
 ----------------------------



EOF
cat /tf/prompt2enter-next-step.txt 1>&2

# You can directly enter the part-3.4 without rebooting.


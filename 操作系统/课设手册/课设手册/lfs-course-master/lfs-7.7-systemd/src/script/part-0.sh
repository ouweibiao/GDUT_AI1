#
#       Linux From Scratch
#      Version 7.7-systemd
#
#    Created by Gerard Beekmans
# Edited by Matthew Burgess and Armin K.
#

#
# Introduction
#

#
# About this script
#
# 0. Reference: http://www.linuxfromscratch.org/
# 1. How to get? (URL: https://gitee.com/openeuler-practice-courses/lfs-course)
# 2. It's for building LFS_TGT_System(7.7-systemd).
# 3. Created on April 14, 2021 by Andrew Zhao at Hangzhou.
# 4. Updated on July 19, 2021 by the student of Lanzhou University.
# 5. There have been several updates since, with the help of numerous people.
#

#
# Acknowledgements
#
# I wish to thank the following people for their help in the preparation of 
# various versions of this script: 
#
# - ZhouYulin, LiBolin and LouJiaming. They are my colleagues.
# - The students of Nankai University
# - The students of Lanzhou University
# - The students of Wuhan University of Technology
# - The students of Beijing Electronic Science & Technology Institute
# - ......
#

#
# Proverbs
#
# "What I cannot create, I do not understand."
# - Richard Phillips Feynman
#
# 箴言
#
# 凡我不能创造的，我就不能理解。
# ——理查德·费曼
#
# 如同火具有热性——做就是得到！
#

#
# Building LFS in Stages
#
#   I. Preparing for the Build
#      Chapters 1–4
#      These chapters are accomplished on the host system.
#
#  II. Building the LFS Cross Toolchain and Temporary Tools
#      Chapter 5
#      The /mnt/lfs partition must be mounted.
#      These chapters must be done as user lfs.
#
# III. Building the LFS System
#      Chapter 6–9
#      The /mnt/lfs partition must be mounted.
#      A few operations, from “Changing Ownership” to 
#      “Entering the Chroot Environment” must be done.
#      The virtual file systems must be mounted.
#
#  IV. Pull Request (PR)
#

#
# In the beginning ...
#

#
# 最开始，我们要完成如下几件事情：
#
# 1. 参照《实验指导手册》在 PC 上完成虚拟机软件的安装；
# 2. 创建虚拟机（安装两块磁盘）；
# 3. 在虚拟机上安装 openEuler 操作系统（注意装到第一块磁盘 sda 上）；
# 4. 对第二块磁盘（sdb）进行分区并格式化；
#
# 在这里，运行于虚拟机之上的 openEuler 操作系统我们通常成为
# 宿主机系统或宿主系统（Host），有时候 host 也包含了虚拟机本身，
# 这个词在其他的语境下还有不同的含义。
#
# Host Config: 
#
# VM Architecture: x64
# OS: openEuler 20.09 / 21.09 as (Other) Linux 4.x 64-bit
#     and Minimal Installation.
#
# Disk Capacity: 
#   sda - recommanded size is 30GB, >=20GB is necessary
#   sdb - recommanded size is 30GB, >=20GB is necessary
#
# Hard Disk Type (of Material):
#   HDD - Hard Disk Driver
#   SSD - Solid State Disk
#
# Hard Disk Interface:
#   IDE  - Integrated Drive Electronics
#   ATA  - Advanced Technology Attachment
#   SATA - Serial ATA
#   SCSI - Small Computer System Interface
#   SAS  - Serial Attached SCSI
#
# 注意：在本实验中创建虚拟机时，按照默认配置，
#       VMware VM 选择的是 SCSI 接口的硬盘，
#       VirtualBox 是 SATA 接口的硬盘。
#       后面编译 kernel 时要选择相应的驱动。
#

#
# 然后，以 root 身份通过 ssh 工具在 Terminal（命令行终端）登录宿主系统。
# 所谓 Terminal：
# - 在 Windows 10 里用 cmd 窗口或 Windows Terminal App；
# - 在 macOS / Linux 里用 Terminal 终端。
#
# 命令如下：
# ssh root@192.168.56.102 # instead of your own IP address
#
# 提示：要知道宿主系统的 IP 地址，可用 `ip a` 命令查看。
#

cd
pwd # /root
whoami # root

# check-point

uname -m # x86_64
uname -a

cat /etc/os-release # openEuler

mkdir -pv ~/tf # temporary files folder

cat > ~/tf/prompt_part-0.txt << "EOF"
        __        __   _
        \ \      / /__| | ___ ___  _ __ ___   ___
         \ \ /\ / / _ \ |/ __/ _ \| '_ ` _ \ / _ \
          \ V  V /  __/ | (_| (_) | | | | | |  __/
           \_/\_/ \___|_|\___\___/|_| |_| |_|\___|

                           _
                          | |_ ___
                          | __/ _ \
                          | || (_) |
                           \__\___/

                               ____     __
           ___  ___  ___ ___  / __/_ __/ /__ ____
          / _ \/ _ \/ -_) _ \/ _// // / / -_) __/
          \___/ .__/\__/_//_/___/\_,_/_/\__/_/   
             /_/                                 



EOF
cat ~/tf/prompt_part-0.txt 1>&2

lsblk
#NAME               MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
#sda                  8:0    0   20G  0 disk
#├─sda1               8:1    0    1G  0 part /boot
#└─sda2               8:2    0   19G  0 part
#  ├─openeuler-root 253:0    0   17G  0 lvm  /
#  └─openeuler-swap 253:1    0    2G  0 lvm  [SWAP]
#sdb                  8:16   0   30G  0 disk
#sr0                 11:0    1 1024M  0 rom

# 从以上信息可以看出 sda 为宿主系统所用，而 sdb 是我们新加的磁盘。
# 注意以上磁盘容量等信息通常不会完全与你的情况一样。

fdisk -l /dev/sdb
#Disk /dev/sdb: ...

blkid
#/dev/sda1: ...
#/dev/sda2: ...


#
# Chapter 0. Preparing a New Partition
#

# 0.1. Introduction

# 0.2. Creating a New Partition

cat > ~/tf/prompt2config-sdb.txt << "EOF"

 ----------------------------
| Config the sdb disk...     |
 ----------------------------



EOF
cat ~/tf/prompt2config-sdb.txt 1>&2

# 给先前添加进来的磁盘分区。
# Start a disk partitioning program such as fdisk to 
# create a Linux native partition.

# Just create a primary partition: sdb1
fdisk /dev/sdb
#
# 提示：依次输入 n p 回车 回车 回车 w。
#
# Welcome to fdisk (util-linux 2.35.2).
# Changes will remain in memory only, until you decide to write them.
# Be careful before using the write command.

# Device does not contain a recognized partition table.
# Created a new DOS disklabel with disk identifier 0x9d1c2177.

# Command (m for help): n
# Partition type
#    p   primary (0 primary, 0 extended, 4 free)
#    e   extended (container for logical partitions)
# Select (default p):

# Using default response p.
# Partition number (1-4, default 1):
# First sector (2048-62914559, default 2048):
# Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-62914559, default 62914559):

# Created a new partition 1 of type 'Linux' and of size 30 GiB.

# Command (m for help): w
# The partition table has been altered.
# Calling ioctl() to re-read partition table.
# Syncing disks.

# deep-into-study: what has changed?
lsblk
#NAME               MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
#sda                  8:0    0   20G  0 disk
#├─sda1               8:1    0    1G  0 part /boot
#└─sda2               8:2    0   19G  0 part
#  ├─openeuler-root 253:0    0   17G  0 lvm  /
#  └─openeuler-swap 253:1    0    2G  0 lvm  [SWAP]
#sdb                  8:16   0   30G  0 disk
#└─sdb1               8:17   0   30G  0 part
#sr0                 11:0    1 1024M  0 rom

blkid
#/dev/sda1: ...
#/dev/sda2: ...
#......
#/dev/sdb1: PARTUUID="a8bbb918-01"

# 0.3. Creating a File System on the Partition

# 对分好区的磁盘进行格式化
# LFS assumes that the root file system (/) is of type ext4.
# mkfs -v -t ext4 /dev/<xxx>
# Replace <xxx> with the name of the LFS partition.
mkfs -v -t ext4 /dev/sdb1

# deep-into-study: what has changed?
blkid
#/dev/sda1: ...
#/dev/sda2: ...
#......
#/dev/sdb1: /dev/sdb1: UUID="4a6c2478-c95c-4274-88a5-fe0526b72f3e" BLOCK_SIZE="4096" TYPE="ext4" PARTUUID="a8bbb918-01"


#
# Next
#

# LFS text in star-wars-style
cat > ~/tf/prompt2enter-next-step.txt << "EOF"
 __       _______     _______.
|  |     |   ____|   /       |
|  |     |  |__     |   (----`
|  |     |   __|     \   \    
|  `----.|  |    .----)   |   
|_______||__|    |_______/    
                              
                              
                              
                              
                              
                              
                              
                              
 ----------------------------
| Please enter Part I.       |
 ----------------------------



EOF
cat ~/tf/prompt2enter-next-step.txt 1>&2


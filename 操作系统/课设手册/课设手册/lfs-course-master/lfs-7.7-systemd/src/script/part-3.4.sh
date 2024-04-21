#
# Part III. Building the LFS System (4)
#

#
# Introduction
#

#
# 在这一部分，我们设置 LFS 目标系统的 GRUB 系统。
#
# 0. 你应该以 root 用户登录宿主系统，如：
#    ssh root@192.168.56.102 # instead of your own IP address
# 1. 要进行 mount 操作：
#    sh ~/mount-and-populate.sh
# 2. 要进入 chrooted 环境：
#    sh ~/chroot2lfs2.sh
# 3. 对 LFS 目标系统的 GRUB 进行设置；
# 4. 对 LFS 目标系统进行一些其他设置。
#

# 8.4. Using GRUB to Set Up the Boot Process

# 8.4.1. Introduction
# Warning: Make a snapshot of system before implement any instructions in this section.

# 8.4.2. GRUB Naming Conventions

# For example, partition sda1 is (hd0,1) to GRUB and sdb3 is (hd1,3).
#                                   | |
#                   hard drive number |
#                                     partition number
#
# The hard drive number starts from zero, but the partition number starts from one for
# normal partitions and five for extended partitions.
# 
# And GRUB does not consider CD-ROM drives to be hard drives.

# 8.4.3. Setting Up the Configuration

# deep-into-study
##ls /boot/grub
# ls: cannot access grub: No such file or directory

grub-install /dev/sdb
#Installing for i386-pc platform.
#Installation finished. No error reported.

# deep-into-study
##ls /boot/grub
# fonts  grubenv  i386-pc  locale

# 8.4.4. Creating the GRUB Configuration File

grub-mkconfig -o /boot/grub/grub.cfg
#Generating grub configuration file ...
#Found linux image: /boot/vmlinuz-3.19-lfs-7.7-systemd
#done

# deep-into-study
##ls /boot/grub
# fonts  grub.cfg  grubenv  i386-pc  locale


#
# Get the GRUB config info of LFS_TGT_SYS here
#
# /boot/grub/grub.cfg
#
##Copy begin
# ### BEGIN /etc/grub.d/10_linux ###
# menuentry 'GNU/Linux' --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-cc2f6dd5-caf9-4e91-9eac-edbfa484a4bc' {
# 	load_video
# 	insmod gzio
# 	insmod part_msdos 
# 	insmod ext2
# 	set root='hd1,msdos1'
# 	if [ x$feature_platform_search_hint = xy ]; then
# 	  search --no-floppy --fs-uuid --set=root --hint-bios=hd1,msdos1 --hint-efi=hd1,msdos1 --hint-baremetal=ahci1,msdos1  cc2f6dd5-caf9-4e91-9eac-edbfa484a4bc
# 	else
# 	  search --no-floppy --fs-uuid --set=root cc2f6dd5-caf9-4e91-9eac-edbfa484a4bc
# 	fi
# 	echo	'Loading Linux 3.19-lfs-7.7-systemd ...'
# 	linux	/boot/vmlinuz-3.19-lfs-7.7-systemd root=/dev/sdb1 ro  
# }
##Copy end.
#

# Do it by sed!

# Get the menuentry info of /boot/grub/grub.cfg of /etc/grub.d/10_linux
# (by chrooted root user of host).
cd /boot/grub/ # LFS_TGT_System's grub directory
cp grub.cfg{,.origin}
sed -n "/^menuentry 'GNU\/Linux'/,/}$/p" grub.cfg > grub.cfg.menuentry

# 以上操作我们把 LFS_TGT_SYS GRUB 配置信息保存在一个文件中供以后使用
# （更新 host 的 GRUB 配置）

# Chapter 9. The End

# 9.1. The End

# Create an /etc/os-release file required by systemd
cd /
cat > /etc/os-release << "EOF"
NAME="Linux From Scratch"
VERSION="7.7-systemd"
ID=lfs
PRETTY_NAME="Linux From Scratch 7.7-systemd"
EOF

# 注意：以上可以设置与您相关的信息。

# For compatibility with non systemd branch
echo 7.7-systemd > /etc/lfs-release
# 注意：以上可以设置与您相关的信息。

# Show the status of your new system with respect to the Linux Standards Base(LSB)
cat > /etc/lsb-release << "EOF"
DISTRIB_ID="Linux From Scratch"
DISTRIB_RELEASE="7.7-systemd"
DISTRIB_CODENAME="Andrew"
DISTRIB_DESCRIPTION="Linux From Scratch"
EOF

# 注意：以上可以设置与您相关的信息。



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
| Please enter Part-3.5      |
| after                      |
| logout                     |
 ----------------------------



EOF
cat /tf/prompt2enter-next-step.txt 1>&2

# Exit from the chrooted environment and 
# to relogin as root user.
##logout

# You can directly enter the part-3.5 without rebooting.



#
# Part III. Building the LFS System (5)
#

#
# Introduction
#

#
# 在这一部分，我们设置 host 的 GRUB 配置文件。
#
# 0. 你应该以 root 用户登录宿主系统，如：
#    ssh root@192.168.56.102 # instead of your own IP address
# 1. 对 host 的 GRUB 配置文件备份以后再进行配置；
# 2. 本节我们借助 sed 命令帮助您完成 grub.cfg 文件的修改，
#    但是您应该了解如何利用 vim 等编辑工具来手动配置。
#

who
#root     pts/0        2021-12-28 11:20 (192.168.11.1)

cd #~
pwd #/root

#
# Update GRUB config of host.
#
# /boot/grub2/ of host
#
##Paste the GRUB config of LFS_TGT_SYS after here
#
# ### BEGIN /etc/grub.d/10_linux ###
#

# Do it by sed!

# Insert the menuentry of LFS_TGT_System grub.cfg to the Host grub.cfg
# (by the root user of host).
cd /boot/grub2/ # host's grub directory
cp grub.cfg{,.origin}
sed -i "/### BEGIN \/etc\/grub.d\/10_linux ###/r $LFS/boot/grub/grub.cfg.menuentry" grub.cfg

# 上述命令我们将以前获取的 LFS_TGT_SYS 的 GRUB 配置信息更新到了
# host 的 GRUB 配置文件中。

# Check
diff grub.cfg{,.origin}
# ...
# < menuentry 'GNU/Linux'...

# !!! ATTENTION !!!
# The final update: 
# Modify 'GNU/Linux' -> 'GNU/Linux {your-number}-{your-name}'


# 9.2. Get Counted
# Ignore it here.

# 9.3. Rebooting the System

# Before rebooting the system, you can unmount 
# the virtual file systems and LFS file system itself.
umount -v $LFS/dev/pts
umount -v $LFS/dev
umount -v $LFS/run
umount -v $LFS/proc
umount -v $LFS/sys
umount -v $LFS

# Question:
# If anything, how can we remount again?
##mount -v -t ext4 /dev/sdb1 $LFS
##sh mount-and-populate.sh


cd
cat > ~/tf/prompt2enter-next-step.txt << "EOF"
 __       _______     _______.
|  |     |   ____|   /       |
|  |     |  |__     |   (----`
|  |     |   __|     \   \    
|  `----.|  |    .----)   |   
|_______||__|    |_______/    
                              
                              
                              
                              
                              
                              
                              
                              
 ----------------------------
| Please reboot               |
| before                      |
| entering Part-3.6.          |
 ----------------------------



EOF
cat ~/tf/prompt2enter-next-step.txt 1>&2

# Now, reboot the system
##shutdown -r now




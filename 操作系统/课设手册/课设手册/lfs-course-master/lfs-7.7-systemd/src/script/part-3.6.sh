#
# Part III. Building the LFS System (6)
#

#
# Introduction
#

#
# 在这一部分，我们进入全新的 LFS 目标系统。
#
# 0. 重启您的宿主系统；
# 1. 从新的 GRUB 菜单项进入 LFS_Target_System！
# 2. 注意是以 root 用户登入；
# 3. 密码是在第 6 章中以“passwd root”命令设置的
#    （在本例中是 Lfs12#$）。
#

#
# Chose 'GNU/Linux, with Linux 3.19-lfs-7.7-systemd'
# Username: root
# Password: (For instance: Lfs12#$)
#
# Please refer to "6.25.3. Setting the root password", or 
# you can set the password again by executing the following steps:
#
# 1. Login the host as root user;
# 2. sh ~/mount-and-populate.sh
# 3. sh ~/chroot2lfs_2.sh
# 4. Run `passwd root` to set password.
#

# 进入 LFS 目标系统后，您可以运行如下命令看看您的新系统：
uname -m 
uname -r
uname -a
cat /etc/os-release
cat /etc/lfs-release
cat /etc/lsb-release
hostname

# 9.4. What Now?

#
# Next: Pull Request (PR)
#


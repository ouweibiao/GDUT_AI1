#
# Part III. Building the LFS System (2)
#

#
# Introduction
#

#
# 在这一节，我们对 LFS_Target_System 进行简单的配置。
#
# 0. 你应该以 root 用户登录宿主系统，如：
#    ssh root@192.168.56.102 # instead of your own IP address
# 1. 要进行 mount 操作：
#    sh ~/mount-and-populate.sh
# 2. 以新的脚本进入 chrooted 环境：
#    sh ~/chroot2lfs2.sh
# 3. 逐步完成 LFS 目标系统的配置任务。
#

# Mount for LFS_Target_System - step 1/2
sh ~/mount-and-populate.sh

cat > ~/chroot2lfs2.sh << "EOF"
#!/bin/bash

# Reentering the chroot environment
chroot "$LFS" /usr/bin/env -i \
    HOME=/root \
    TERM="$TERM" \
    PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login

EOF

# Chroot to LFS_Target_System again - step 2/2
sh ~/chroot2lfs2.sh

# Ignore this cleaning up
##rm -rf /tmp/*
##rm -rf /tools

# Chapter 7. System Configuration and Bootscripts

# 7.1. Introduction

# 7.2. General Network Configuration

# 7.2.1. Network Interface Configuration Files

ip link
ip a
ifconfig
#  enp0s3    Link encap:Ethernet  HWaddr 08:00:27:35:4E:16
#            inet addr:10.0.2.15  Bcast:10.0.2.255  Mask:255.255.255.0
#            ......
# 
#  enp0s8    Link encap:Ethernet  HWaddr 08:00:27:31:6C:0A
#            inet addr:192.168.56.102  Bcast:192.168.56.255  Mask:255.255.255.0
#            ......
#
#  lo        Link encap:Local Loopback
#            inet addr:127.0.0.1  Mask:255.0.0.0
#            ......

# To creates a basic configuration file for Static IP setup:
cat > /etc/systemd/network/10-static-enp0s8.network << "EOF"
[Match]
Name=enp0s8
[Network]
Address=192.168.56.122/24
Gateway=192.168.56.1
DNS=192.168.56.1
EOF

# To creates a basic configuration file for DHCP setup:
##cat > /etc/systemd/network/10-dhcp-enp0s8.network << "EOF"
##[Match]
##Name=enp0s8
##[Network]
##DHCP=yes
##EOF

# 7.2.2. Creating the /etc/resolv.conf File

cat > /etc/resolv.conf << "EOF"
# Begin /etc/resolv.conf
nameserver 114.114.114.114

# End /etc/resolv.conf
EOF

##ln -sfv /run/systemd/resolve/resolv.conf /etc/resolv.conf # ???

# 7.2.3. Configuring the system hostname

echo "andrew" > /etc/hostname # Please instead of your own name

# 7.2.4. Customizing the /etc/hosts File

# Please instead of your own email address
cat > /etc/hosts << "EOF"
# Begin /etc/hosts (network card version)
127.0.0.1 localhost
::1 localhost
192.168.56.122 andrew@manjucc.com
# End /etc/hosts (network card version)
EOF


# 7.3. Overview of Device and Module Handling

# 7.4. Creating Custom Symlinks to Devices

# 7.5. System Time Configuration

# 7.6. Console Configuration

# 7.7. Configuring the System Locale

# 7.8. Creating the /etc/inputrc File

# 7.9. Creating the /etc/shells File

# 7.10 Configuration of systemd

# 7.11 Creating the /etc/fstab File

cat > /etc/fstab << "EOF"
# Begin /etc/fstab
# file system    mount-point    type        options                dump    fsck
#                                                                          order
/dev/sdb1        /              ext4        defaults               1       1

# End /etc/fstab
EOF


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
| Please enter Part-3.3.     |
 ----------------------------



EOF
cat /tf/prompt2enter-next-step.txt 1>&2

# You can directly enter the part-3.3 without rebooting.



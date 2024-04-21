#
# Part III. Building the LFS System (0)
#

#
# Introduction
#

#
# 本节为构建 LFS_Target_System 基本系统软件做准备：
#
# 0. 你应该以 root 用户登录 host；
#    ssh root@192.168.56.102 # instead of your own IP address
# 1. Change the ownership of $LFS/tools/；
# 2. 创建并运行 mount-and-populate.sh 脚本；
# 3. 创建并运行 chroot2lfs.sh 脚本（为了不损坏宿主系统，我们要进入 chrooted 环境）；
#

#
# Chapter 6. Installing Basic System Software
#

# 6.1. Introduction

# 6.2. Preparing Virtual Kernel File Systems and etc.

cd # ~

cat > ~/tf/prompt_part-3.txt << "EOF"
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

             ____            _       ___ ___ ___
            |  _ \ __ _ _ __| |_    |_ _|_ _|_ _|
            | |_) / _` | '__| __|    | | | | | |
            |  __/ (_| | |  | |_     | | | | | |
            |_|   \__,_|_|   \__|   |___|___|___|

EOF
cat ~/tf/prompt_part-3.txt 1>&2

ls -l $LFS/
#...
#drwxr-xr-x. 13 lfs  root  4096 Dec 27 11:28 tools

# Change the ownership of $LFS/tools/
# Please refer to "5.36. Changing Ownership",
# but I think it's not necessary in most of the cases.
chown -Rv root:root $LFS/tools

# Check
ls -l $LFS/
#...
#drwxr-xr-x. 13 root root  4096 Dec 27 11:28 tools

# Do it by root user
mkdir -pv $LFS/{dev,proc,sys,run}

# 6.2.1. Creating Initial Device Nodes

mknod -m 600 $LFS/dev/console c 5 1
mknod -m 666 $LFS/dev/null c 1 3

# 6.2.2. Mounting and Populating /dev
# 6.2.3. Mounting Virtual Kernel File Systems 

# deep-into-study
# (1) mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
# (2) mount -v --bind /dev/pts $LFS/dev/pts -o gid=5,mode=620
# 注意：上面第一条语句来自 LFS-BOOK，but it doesn't work，
#       于是我们换成了第二条语句，and it works！

# Mount for LFS_Target_System - step 1/2
cat > ~/mount-and-populate.sh << "EOF"
#!/bin/bash

# Mounting and populating /dev
mount -v --bind /dev $LFS/dev
# Mounting virtual kernel file systems 
mount -v --bind /dev/pts $LFS/dev/pts -o gid=5,mode=620
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run
EOF

sh ~/mount-and-populate.sh

cat > ~/tf/dev-shm.sh << "EOF"
#!/bin/bash

if [ -h $LFS/dev/shm ]; then
        mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi
EOF

sh ~/tf/dev-shm.sh

# 6.3. Package Management

# 6.4. Entering the Chroot Environment

cat > ~/chroot2lfs.sh << "EOF"
#!/bin/bash

# Entering the chroot environment
chroot "$LFS" /tools/bin/env -i \
    HOME=/root \
    TERM="$TERM" \
    PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
    /tools/bin/bash --login +h
EOF

# chroot to LFS_Target_System - step 2/2
sh ~/chroot2lfs.sh
#I have no name!:/#
# Note that the bash prompt will say I have no name! 
# This is normal because the /etc/passwd file 
# has not been created yet.
# 提示：此时的根目录“/”即原宿主系统的“$LFS”目录。


# 6.5. Creating Directories

cd /
# 现在是 chrooted 之后的根目录，即原 $LFS 目录

cat > /tf/lambda-of-creating-directories.sh << "EOF"
#!/bin/bash

mkdir -pv /{bin,boot,etc/{opt,sysconfig},home,lib/firmware,mnt,opt}
mkdir -pv /{media/{floppy,cdrom},sbin,srv,var}
install -dv -m 0750 /root
install -dv -m 1777 /tmp /var/tmp
mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -v /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -v /usr/libexec
mkdir -pv /usr/{,local/}share/man/man{1..8}
case $(uname -m) in
x86_64) ln -sv lib /lib64
ln -sv lib /usr/lib64
ln -sv lib /usr/local/lib64 ;;
esac
mkdir -v /var/{log,mail,spool}
ln -sv /run /var/run
ln -sv /run/lock /var/lock
mkdir -pv /var/{opt,cache,lib/{color,misc,locate},local}
EOF
sh /tf/lambda-of-creating-directories.sh

# 6.6. Creating Essential Files and Symlinks

ln -sv /tools/bin/{bash,cat,echo,pwd,stty} /bin
ln -sv /tools/bin/perl /usr/bin
ln -sv /tools/lib/libgcc_s.so{,.1} /usr/lib
ln -sv /tools/lib/libstdc++.so{,.6} /usr/lib
sed 's/tools/usr/' /tools/lib/libstdc++.la > /usr/lib/libstdc++.la
ln -sv bash /bin/sh

# For historical reason
ln -sv /proc/self/mounts /etc/mtab

# Create the /etc/passwd file
cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/bin/false
daemon:x:6:6:Daemon User:/dev/null:/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/var/run/dbus:/bin/false
systemd-bus-proxy:x:72:72:systemd Bus Proxy:/:/bin/false
systemd-journal-gateway:x:73:73:systemd Journal Gateway:/:/bin/false
systemd-journal-remote:x:74:74:systemd Journal Remote:/:/bin/false
systemd-journal-upload:x:75:75:systemd Journal Upload:/:/bin/false
systemd-network:x:76:76:systemd Network Management:/:/bin/false
systemd-resolve:x:77:77:systemd Resolver:/:/bin/false
systemd-timesync:x:78:78:systemd Time Synchronization:/:/bin/false
nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
EOF

# Create the /etc/group file
cat > /etc/group << "EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
systemd-journal:x:23:
input:x:24:
mail:x:34:
systemd-bus-proxy:x:72:
systemd-journal-gateway:x:73:
systemd-journal-remote:x:74:
systemd-journal-upload:x:75:
systemd-network:x:76:
systemd-resolve:x:77:
systemd-timesync:x:78:
nogroup:x:99:
users:x:999:
EOF

# To remove the “I have no name!” prompt
exec /tools/bin/bash --login +h

# Initialize the log files and give them proper permissions
touch /var/log/{btmp,lastlog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664 /var/log/lastlog
chmod -v 600 /var/log/btmp

cd / 
cp /material/lfs-course/lfs-7.7-systemd/src/script/part-3.1.sh ./


#
# Next
#

#
# 接下来在此 chrooted 环境下运行脚本 part-3.1.sh
# 如果重启了宿主系统，则
# 1. 以 root 身份登录宿主系统；
# 2. 执行 mount-and-populate.sh 脚本；
# 3. 执行 chroot2lfs.sh 脚本进入 chrooted 环境；
# 4. 完成第6章其余的构建。
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
| Please enter Part-3.1.     |
 ----------------------------



EOF
cat /tf/prompt2enter-next-step.txt 1>&2

# Now exit chrooted environment and reboot the host to relogin
##exit
##reboot


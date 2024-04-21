#
# Part I. Preparing for the Build
#

#
# Introduction
#

#
# 在这一部分，我们需要完成以下几件事情：
#
# 0. 注册 Gitee 账号并签署个人 CLA。
#    Gitee 网站：https://gitee.com/signup
#    签署 CLA 的网址：
#    https://clasign.osinfra.cn/sign/Z2l0ZWUlMkZvcGVuZXVsZXI=
#    签署的时候用的邮箱要和 gitee 账号的邮箱一致。
#    有关资源请参考 openEuler 门户网站：
#    https://www.openeuler.org/zh/
# 1. 进一步完善宿主系统的软件环境；
# 2. 为第一次使用 git 配置 git 账号；
# 3. 设置 $LFS 变量并将 sdb 挂载到前者代表的目录下；
# 4. 设置 lfs 用户；
# 5. 获取 LFS packages 和 lfs-course 资料。
#

# Login as root user, for instance:
# ssh root@192.168.56.102 # instead of your own IP address

whoami # root

#
# Chapter 1. First Things First
#

cd ~
pwd # /root

cat > ./tf/prompt_part-1.txt << "EOF"
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

             ____            _       ___ 
            |  _ \ __ _ _ __| |_    |_ _|
            | |_) / _` | '__| __|    | |
            |  __/ (_| | |  | |_     | |
            |_|   \__,_|_|   \__|   |___|

EOF
cat ./tf/prompt_part-1.txt  1>&2

#
# Preparing software for the Build
#

yum group install -y "Development Tools"
yum install -y bc
yum install -y openssl-devel

yum install -y texinfo # for makeinfo

yum install -y vim
yum install -y nano # Another choice instead of vim

#yum install -y git # If any

#
# 下面是对宿主系统做一些检查
#

cat > ./version-check.sh << "EOF"
#!/bin/bash
# Simple script to list version numbers of critical development tools
export LC_ALL=C
bash --version | head -n1 | cut -d" " -f2-4
MYSH=$(readlink -f /bin/sh)
echo "/bin/sh -> $MYSH"
echo $MYSH | grep -q bash || echo "ERROR: /bin/sh does not point to bash"
unset MYSH
echo -n "Binutils: "; ld --version | head -n1 | cut -d" " -f3-
bison --version | head -n1
if [ -h /usr/bin/yacc ]; then
echo "/usr/bin/yacc -> `readlink -f /usr/bin/yacc`";
elif [ -x /usr/bin/yacc ]; then
echo yacc is `/usr/bin/yacc -V | head -n1`
else
echo "yacc not found"
fi
bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f1,6-
echo -n "Coreutils: "; chown --version | head -n1 | cut -d")" -f2
diff --version | head -n1
find --version | head -n1
gawk --version | head -n1
if [ -h /usr/bin/awk ]; then
echo "/usr/bin/awk -> `readlink -f /usr/bin/awk`";
elif [ -x /usr/bin/awk ]; then
echo awk is `/usr/bin/awk --version | head -n1`
else
echo "awk not found"
fi
gcc --version | head -n1
g++ --version | head -n1
ldd --version | head -n1 | cut -d" " -f2- # glibc version
grep --version | head -n1
gzip --version | head -n1
cat /proc/version
m4 --version | head -n1
make --version | head -n1
patch --version | head -n1
echo Perl `perl -V:version`
sed --version | head -n1
tar --version | head -n1
makeinfo --version | head -n1 # texinfo version
xz --version | head -n1
echo 'int main(){}' > dummy.c && g++ -o dummy dummy.c
if [ -x dummy ]
then echo "g++ compilation OK";
else echo "g++ compilation failed"; fi
rm -f dummy.c dummy
EOF
bash version-check.sh
#bash, version 5.0.17(1)-release
#/bin/sh -> /usr/bin/bash
#Binutils: (GNU Binutils) 2.34
#bison (GNU Bison) 3.6.4
#yacc is /usr/bin/yacc - 1.9 20200330
#bzip2,  Version 1.0.8, 13-Jul-2019.
#Coreutils:  8.32
#diff (GNU diffutils) 3.7
#find (GNU findutils) 4.7.0
#GNU Awk 5.1.0, API: 3.0 (GNU MPFR 4.1.0, GNU MP 6.2.0)
#/usr/bin/awk -> /usr/bin/gawk
#gcc (GCC) 9.3.1
#g++ (GCC) 9.3.1
#(GNU libc) 2.31
#grep (GNU grep) 3.4
#gzip 1.10
#Linux version 4.19.140-2009.4.0.0048.oe1.x86_64 (abuild@ecs-obsworker-207) (gcc version 9.3.1 (GCC)) #1 SMP Thu Sep 24 09:39:46 UTC 2020
#m4 (GNU M4) 1.4.18
#GNU Make 4.3
#GNU patch 2.7.6
#Perl version='5.32.0';
#sed (GNU sed) 4.8
#tar (GNU tar) 1.32
#texi2any (GNU texinfo) 6.7
#xz (XZ Utils) 5.2.5
#g++ compilation OK

# 基本上如上所示结果表示宿主系统环境具备构建 LFS 的条件，
# 具体的分析可参考 LFS-BOOK。

# More determination
cat > ./library-check.sh << "EOF"
#!/bin/bash
for lib in lib{gmp,mpfr,mpc}.la; do
echo $lib: $(if find /usr/lib* -name $lib|
grep -q $lib;then :;else echo not;fi) found
done
unset lib
EOF
bash library-check.sh
#libgmp.la: not found
#libmpfr.la: not found
#libmpc.la: not found

# 出现如上所示结果可以忽略之。


#
# Config git account
#

cat > ~/tf/prompt2config-git-account.txt << "EOF"

 ----------------------------
| Config your git account... |
 ----------------------------



EOF
cat ~/tf/prompt2config-git-account.txt 1>&2

# 如果你还没有配置 Gitee 账号，请在这里配置它。
# 注意要配置成签署 CLA 的用户名和邮箱。
# You need to set your git account when you first run it.
git config --global user.name "your-user-name"
git config --global user.email "your-email-address-on-gitee"


#
# Chapter 2. Preparing a New Partition
#
# 2.1. Introduction
# 2.2. Creating a New Partition
# 2.3. Creating a File System on the Partition

# We've done these steps in part 0.

# 2.4. Setting The $LFS Variable

#
# 下面设置 LFS 变量——一个十分关键的变量。
#
# 将“export LFS=/mnt/lfs”命令写到 .bash_profile 中
# 使得宿主系统每次启动时自动设置并导出 $LFS 变量。
cp /root/.bash_profile{,.origin}
echo "export LFS=/mnt/lfs" >> /root/.bash_profile

# check-point
diff /root/.bash_profile{,.origin}
#13d12
#< export LFS=/mnt/lfs

# deep-into-study
echo $LFS # 此时该值为空

# 我们现在不必重启宿主系统，而是用 source 命令使得
# 对 .bash_profile 的修改生效
source /root/.bash_profile

# check-point
echo $LFS # 若输出“/mnt/lfs”则表示设置已经生效
#/mnt/lfs

# 2.5. Mounting the New Partition

mkdir -pv $LFS

# deep-into-study
ls $LFS # 没有看到 $LFS 目录下有任何东西
# 

# 我们通过修改 fstab 使宿主系统每次启动时自动挂载
# 构建LFS目标系统的 sdb1 分区
# Setting fstab instead of doing "mount -v -t ext4 /dev/sdb1 $LFS"
cp /etc/fstab{,.origin}
echo "/dev/sdb1 /mnt/lfs ext4 defaults 1 1" >> /etc/fstab

# check-point
diff /etc/fstab{,.origin}
#15d14
#< /dev/sdb1 /mnt/lfs ext4 defaults 1 1

# 我们现在不必重启系统，而是用“mount -a”命令
# 自动挂载 /etc/fstab 文件没有挂载的设备
mount -a
# or restart the host to make the setting effective
#reboot

# deep-into-study
mount
#...
#/dev/sdb1 on /mnt/lfs type ext4 (rw,relatime,seclabel)

# deep-into-study: what has changed?
ls $LFS
#lost+found
# 从以上信息可以看出 sdb 已经挂载在 /mnt/lfs/ 目录下。

#
# Chapter 3. Packages and Patches
#

# 3.1. Introduction

# To learn the packages for LFS, please refer to 
# http://www.linuxfromscratch.org/lfs/packages.html#packages
# http://ftp.osuosl.org/pub/lfs/lfs-packages/

# 3.2. All Packages
# 3.3. Needed Patches

#
# Chapter 4. Final Preparations
#

# 4.1. Introduction

# 4.2. Creating a limited directory layout in LFS filesystem

cd $LFS
mkdir -v $LFS/sources

# deep-into-study
ls -l
#...
#drwxr-xr-x. 2 root root  4096 Dec 24 10:14 sources

# Make this directory writable and sticky
chmod -v a+wt $LFS/sources

# deep-into-study: what has changed?
ls -l
#drwxrwxrwt. 2 root root  4096 Dec 24 10:14 sources

# Creating the $LFS/tools Directory to separate the cross-compiler in 
# the chapter 6 from the other programs
mkdir -pv $LFS/tools
ln -sv $LFS/tools /

# Create material and temporary file directories and 
# make them writable and sticky 
# - added by andrew
mkdir -v $LFS/{material,tf}
chmod -v a+wt $LFS/{material,tf}

# deep-into-study
ls -l
#...
#drwxrwxrwt. 2 root root  4096 Dec 27 17:07 material
#drwxrwxrwt. 2 root root  4096 Dec 27 17:07 sources
#drwxrwxrwt. 2 root root  4096 Dec 27 17:07 tf
#drwxr-xr-x. 2 root root  4096 Dec 27 17:07 tools

# 4.3. Adding the LFS User

groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs

cat > $LFS/tf/prompt2set-password.txt << "EOF"
 ----------------------------
| Please set lfs's password. |
 ----------------------------



EOF
cat $LFS/tf/prompt2set-password.txt 1>&2

passwd lfs
# Input password by handwork.
# For instance: Lfs@123

# Grant lfs full access to all directories under $LFS 
# by making lfs the directory owner

# Changed ownership of these folders from root to lfs
chown -v lfs $LFS/tools
chown -v lfs $LFS/sources
chown -v lfs $LFS/{material,tf}

# deep-into-study: what have changed?
ls -l
#...
#drwxrwxrwt. 2 lfs  root  4096 Dec 27 17:07 material
#drwxrwxrwt. 2 lfs  root  4096 Dec 27 17:07 sources
#drwxrwxrwt. 2 lfs  root  4096 Dec 27 17:07 tf
#drwxr-xr-x. 2 lfs  root  4096 Dec 27 17:07 tools

#
# Add sudoer for lfs user - added by Andrew Zhao
#

cp /etc/sudoers{,.origin}
sed -i '/^root/a\lfs     ALL=(ALL)       ALL' /etc/sudoers

# check-point
diff /etc/sudoers{,.origin}
#......
#< lfs     ALL=(ALL)       ALL


#
# Now, login as lfs user
#
su - lfs
#[lfs@localhost ~]$


# deep-into-study
whoami # lfs

echo $HOME
#/home/lfs

# sudo: check lfs password
cat > $LFS/tf/prompt2enter-lfs-password.txt << "EOF"




 ----------------------------
| sudo: need lfs password    |
 ----------------------------








EOF
cat $LFS/tf/prompt2enter-lfs-password.txt 1>&2

# test
sudo ls /

# 4.4. Setting Up the Environment

cd ~ # /home/lfs

# While logged in as user lfs, issue the following command 
# to create a new .bash_profile
cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

# The new instance of the shell reads, and executes, the .bashrc file instead
cat > ~/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
export LFS LC_ALL LFS_TGT PATH
EOF

ls -la
#...
#-rw-r--r--. 1 lfs  lfs    59 Dec 24 10:55 .bash_profile
#-rw-r--r--. 1 lfs  lfs   138 Dec 24 10:55 .bashrc

# deep-into-study
# 上述脚本要好好研究一下，简单地说，它为 lfs 用户
# 设置 LFS、LC_ALL、LFS_TGT 等重要变量的值，
# 在接下来的第5章中，要体会这些变量是如何辅助构建临时工具链的。

# deep-into-study
echo $LFS # 此时该值为空
echo $PATH
#/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin

# To have the environment fully prepared for building the temporary tools, 
# source the just-created user profile.
source ~/.bash_profile
#lfs:~$

#
# check-point
#

whoami # lfs

echo $LFS
#/mnt/lfs

echo $LFS_TGT
#x86_64-lfs-linux-gnu

lfs:~$ echo $LC_ALL
#POSIX

echo $PATH
#/tools/bin:/bin:/usr/bin

# More determination, to make sure that ...
# bash is the shell in use.
# sh is a symbolic link to bash.
# /usr/bin/awk is a symbolic link to gawk.
# /usr/bin/yacc is there.

cat /etc/shells
#/bin/sh
#/bin/bash
#/usr/bin/sh
#/usr/bin/bash

ls -l /bin/sh
#lrwxrwxrwx. 1 root root 4 Sep 27  2020 /bin/sh -> bash

echo $SHELL
#/bin/bash

ls -l /usr/bin/awk
#lrwxrwxrwx. 1 root root 4 Sep 27  2020 /usr/bin/awk -> gawk

ls -l /usr/bin/yacc
#-rwxr-xr-x. 1 root root 109128 Sep 27  2020 /usr/bin/yacc

whereis bison
#bison: /usr/bin/bison /usr/share/bison


# 4.5 Get LFS packages and lfs-course resource

#
# 以 lfs 用户身份获取 LFS packages 以及再次获取 lfs-course 资料
#
cd $LFS/material
wget https://zhuanyejianshe.obs.cn-north-4.myhuaweicloud.com/chuangxinshijianke/lfs-packages-7.7-systemd.tar

#sudo chown lfs lfs-packages-7.7-systemd.tar # added by andrew, but it's not necessary in most of the cases

# Check
ls -l
#...
#-rw-r--r--. 1 lfs lfs 344903680 Jul  2 18:08 lfs-packages-7.7-systemd.tar

# 或者用下面链接，速度可能会慢些：
#wget http://ftp.osuosl.org/pub/lfs/lfs-packages/lfs-packages-7.7-systemd.tar

# 我们也可以先将其先下载到 PC，然后用 scp 命令拷贝到宿主系统：
# scp lfs-packages-7.7-systemd.tar root@192.168.56.102:/mnt/lfs/material
# 在上述命令中，请使用您自己宿主系统的 IP 地址替代示例中的 IP 地址。

# Get the lfs-course material( to get cfns-4.9.2.patch) 
git clone https://gitee.com/openeuler-practice-courses/lfs-course.git
# added by gavin: git clone https://gitee.com/openeuler/lfs-course.git
##git clone -b lfs_v1.3 https://gitee.com/glibc/lfs-course.git # Instead of the official repository shown above

# Check
ls -l $LFS/material/
#...
#drwxr-xr-x. 4 lfs lfs      4096 Dec 27 10:59 lfs-course
#-rw-r--r--. 1 lfs lfs 344903680 Jul  2 18:08 lfs-packages-7.7-systemd.tar

sudo cp $LFS/material/lfs-course/lfs-7.7-systemd/src/code/patch/gcc-4.9.2/cfns-4.9.2.patch $LFS/

# 注意此时 $LFS 目录下应该有如下文件/文件夹
# Check
ls -l $LFS
#...
#-rw-r--r--. 1 root root   493 Dec 27 17:19 cfns-4.9.2.patch
#drwxrwxrwt. 3 lfs  root  4096 Dec 27 17:18 material
#drwxrwxrwt. 2 lfs  root  4096 Dec 27 17:07 sources
#drwxrwxrwt. 2 lfs  root  4096 Dec 27 17:07 tf
#drwxr-xr-x. 2 lfs  root  4096 Dec 27 17:07 tools


# 4.6 Final Preparations

#
# 为了让第5章的编译能够一气呵成，在这里预先对一些文件进行准备。
#

cd $LFS
tar xf ./material/lfs-packages-7.7-systemd.tar -C ./sources

#
# Prepare files for "5.7. Glibc-2.21"
#

cd $LFS/sources/
tar xJf glibc-2.21.tar.xz
cd glibc-2.21

##patch -p1 < ../glibc-2.21-fhs-1.patch

cat > ./glibc-lambda.sh << "EOF"
#!/bin/sh

if [ ! -r /usr/include/rpc/types.h ]; then
echo "ture"
fi
EOF
sh glibc-lambda.sh

sudo ls /usr/include/rpc/ # To input the lfs password
sudo mv /usr/include/rpc/netdb.h{,.origin}
sudo cp -v $LFS/sources/glibc-2.21/sunrpc/rpc/*.h /usr/include/rpc/

# Clean
cd $LFS/sources/
rm -rf glibc-2.21

cd $LFS
sudo cp ./material/lfs-course/lfs-7.7-systemd/src/script/part-2.sh ./
sudo chown -v lfs ./part-2.sh

#
# 为了保证我们只能以 lfs 用户构建临时工具链（Part II），
# 我们重启宿主系统以 lfs 用户重新登录。
#

#
# Next
#

cd $LFS
cat > ./tf/prompt2enter-next-step.txt << "EOF"
 __       _______     _______.
|  |     |   ____|   /       |
|  |     |  |__     |   (----`
|  |     |   __|     \   \    
|  `----.|  |    .----)   |   
|_______||__|    |_______/    
                              
                              
                              
                              
                              
                              
                              
                              
 ----------------------------
| Please enter Part II.      |
 ----------------------------



EOF
cat ./tf/prompt2enter-next-step.txt 1>&2

# Relogin as lfs user
##exit   # logout from lfs user and  
##reboot # as root user


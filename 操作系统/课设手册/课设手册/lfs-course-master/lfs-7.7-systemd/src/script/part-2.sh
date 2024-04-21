#
# Part II. Building the LFS Cross Toolchain and Temporary Tools
#

#
# Introduction
#

#
# 在这一部分，我们编译临时工具链，请注意以下事项：
#
# 1. 为了不损坏宿主系统，以 lfs 用户编译和构建临时工具链；
# 2. 注意在需要用到 sudo 的操作的地方（5.7. Glibc-2.21）
#    我们已经提前在上一部分解决了；
# 3. 可以以“sh part-2.sh > $LFS/tf/building_output.log”的方式构建本章内容，
#    但请体会其构建流程（并且需要查看屏幕是否有致命错误输出）。
# 4. 对于错误输出，凡是警告皆可（暂时）忽略，一个错误便要重来，
#    但 Error (ignored) 的可以除外。
#

# Chapter 5. Constructing a Temporary System

# 5.1. Introduction

# 5.2. Toolchain Technical Notes

# 5.3. General Compilation Instructions

# For each package:
# a. Using the tar program, extract the package to be built. In Chapter 5 and Chapter 6, ensure you are
#    the lfs user when extracting the package.
# b. Change to the directory created when the package was extracted.
# c. Follow the book's instructions for building the package.
# d. Change back to the sources directory.
# e. Delete the extracted source directory unless instructed otherwise.


# 注意这一章需要以 lfs 用户登录
# ssh lfs@192.168.56.102 # instead of your own IP address

cd $LFS

cat > ./tf/prompt_part-2.txt << "EOF"
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

             ____            _       ___ ___
            |  _ \ __ _ _ __| |_    |_ _|_ _|
            | |_) / _` | '__| __|    | | | |
            |  __/ (_| | |  | |_     | | | |
            |_|   \__,_|_|   \__|   |___|___|

EOF
cat ./tf/prompt_part-2.txt 1>&2


#
# 配置 make 以多线程运行
#

# 查看核数
lscpu
cat /proc/cpuinfo | grep "processor" | wc -l
grep processor /proc/cpuinfo | wc -l
#4
# 在这里是 4 核，可能与你的情况不同。

# Set an environment variable to tell the make program 
# that how many processors are available
export MAKEFLAGS='-j 4'
echo $MAKEFLAGS 1>&2
#-j 4


#
# 5.4. Binutils-2.25 - Pass 1
#

cd $LFS/sources/
tar xjf binutils-2.25.tar.bz2
cd binutils-2.25
mkdir build && cd build

../configure --prefix=/tools --with-sysroot=$LFS --with-lib-path=/tools/lib --target=$LFS_TGT --disable-nls --disable-werror
make

# Architecture determination
uname -m # x86_64

# For x86_64 platform
mkdir -v /tools/lib && ln -sv lib /tools/lib64

make install

# Clean
cd $LFS/sources/
rm -rf binutils-2.25


#
# 5.5. GCC-4.9.2 - Pass 1
#

cd $LFS/sources/
tar xjf gcc-4.9.2.tar.bz2
cd gcc-4.9.2

# GCC now requires the GMP, MPFR and MPC packages.
tar -xf ../mpfr-3.1.2.tar.xz
mv -v mpfr-3.1.2 mpfr
tar -xf ../gmp-6.0.0a.tar.xz
mv -v gmp-6.0.0 gmp
tar -xf ../mpc-1.0.2.tar.gz
mv -v mpc-1.0.2 mpc

# gavin

# The following command will change the location of GCC's default dynamic linker to use the one installed in /tools.
# It also removes /usr/include from GCC's include search path. Issue:
cat > ./gcc-lambda.sh << "EOF"
#!/bin/sh

for file in \
    $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
do
    cp -uv $file{,.orig}
    sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
        -e 's@/usr@/tools@g' $file.orig > $file
    echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
    touch $file.orig
done
EOF

# Just for character set issue if any.
##vim lambda.sh # :set ff=unix
sh gcc-lambda.sh

sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure

cd $LFS/sources/gcc-4.9.2

#
# VERY IMPORTANT!!!
#
# The bug is on the GCC 4.9 side, so either you need to patch it, 
# or build with -std=gnu++98 - then __GNUC_STDC_INLINE__ 
# will not be defined and it ought to compile fine.
#
# Now I modified this file in my own way. And maybe you'd better  
# fix it by a 'political correctness' way. 
#
cp $LFS/cfns-4.9.2.patch ./
patch -p1 < cfns-4.9.2.patch

mkdir -v build
cd build/
../configure --target=$LFS_TGT --prefix=/tools --with-sysroot=$LFS --with-newlib --without-headers --with-local-prefix=/tools --with-native-system-header-dir=/tools/include --disable-nls --disable-shared --disable-multilib --disable-decimal-float --disable-threads --disable-libatomic --disable-libgomp --disable-libitm --disable-libquadmath --disable-libsanitizer --disable-libssp --disable-libvtv --disable-libcilkrts --disable-libstdc++-v3 --enable-languages=c,c++

make
make install

# Clean
cd $LFS/sources/
rm -rf gcc-4.9.2


#
# 5.6. Linux-3.19 API Headers
#

cd $LFS/sources/
tar xJf linux-3.19.tar.xz
cd linux-3.19

make mrproper
make INSTALL_HDR_PATH=dest headers_install
cp -rv dest/include/* /tools/include

# Clean
cd $LFS/sources/
rm -rf linux-3.19


#
# 5.7. Glibc-2.21
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

#
# It has done in Part I that prepare files for glibc.
#
# {{{
#sudo ls /usr/include/rpc/ # To input the lfs password
#sudo mv /usr/include/rpc/netdb.h{,.origin}
#sudo cp -v $LFS/sources/glibc-2.21/sunrpc/rpc/*.h /usr/include/rpc/
# }}}

cp sysdeps/i386/i686/multiarch/mempcpy_chk.S{,.origin}
sed -e '/ia32/s/^/1:/' -e '/SSE2/s/^1://' -i sysdeps/i386/i686/multiarch/mempcpy_chk.S

# Do these by lfs user
mkdir build && cd build

../configure --prefix=/tools --host=$LFS_TGT --build=$(../glibc-2.21/scripts/config.guess) --disable-profile --enable-kernel=2.6.32 --with-headers=/tools/include libc_cv_forced_unwind=yes libc_cv_ctors_header=yes libc_cv_c_cleanup=yes

make
make install

echo 'int main(){}' > dummy.c
$LFS_TGT-gcc dummy.c
readelf -l a.out | grep ': /tools'
#      [Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2]
rm -v dummy.c a.out

# Clean
cd $LFS/sources/
rm -rf glibc-2.21


#
# 5.8. Libstdc++-4.9.2
#

cd $LFS/sources/
tar xjf gcc-4.9.2.tar.bz2
cd gcc-4.9.2

mkdir build && cd build

../libstdc++-v3/configure --host=$LFS_TGT --prefix=/tools --disable-multilib --disable-shared --disable-nls --disable-libstdcxx-threads --disable-libstdcxx-pch --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/4.9.2

make
make install

# Clean
cd $LFS/sources/
rm -rf gcc-4.9.2

#
# 5.9. Binutils-2.25 - Pass 2
#

cd $LFS/sources/
tar xjf binutils-2.25.tar.bz2
cd binutils-2.25
mkdir build && cd build

CC=$LFS_TGT-gcc AR=$LFS_TGT-ar RANLIB=$LFS_TGT-ranlib ../configure --prefix=/tools --disable-nls --disable-werror --with-lib-path=/tools/lib --with-sysroot

make
make install

make -C ld clean
make -C ld LIB_PATH=/usr/lib:/lib
cp -v ld/ld-new /tools/bin

# Clean
cd $LFS/sources/
rm -rf binutils-2.25


#
# 5.10. GCC-4.9.2 - Pass 2
#

cd $LFS/sources/
tar xjf gcc-4.9.2.tar.bz2
cd gcc-4.9.2

# This build of GCC now requires the full internal header.
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h

# Once again, change the location of GCC's default dynamic linker to use the one installed in /tools.
cat > ./gcc-lambda.sh << "EOF"
#!/bin/sh

for file in \
    $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
do
    cp -uv $file{,.orig}
    sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
        -e 's@/usr@/tools@g' $file.orig > $file
    echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
    touch $file.orig
done
EOF

sh gcc-lambda.sh

# As in the first build of GCC it requires the GMP, MPFR and MPC packages. 
# Unpack the tarballs and move them into the required directory names:
tar -xf ../mpfr-3.1.2.tar.xz
mv -v mpfr-3.1.2 mpfr
tar -xf ../gmp-6.0.0a.tar.xz
mv -v gmp-6.0.0 gmp
tar -xf ../mpc-1.0.2.tar.gz
mv -v mpc-1.0.2 mpc

cd $LFS/sources/gcc-4.9.2

cp $LFS/cfns-4.9.2.patch ./
patch -p1 < cfns-4.9.2.patch

# Create a separate build directory again:
mkdir -v build
cd build/

CC=$LFS_TGT-gcc CXX=$LFS_TGT-g++ AR=$LFS_TGT-ar RANLIB=$LFS_TGT-ranlib ../configure --prefix=/tools --with-local-prefix=/tools --with-native-system-header-dir=/tools/include --enable-languages=c,c++ --disable-libstdcxx-pch --disable-multilib --disable-bootstrap --disable-libgomp

make
make install

ln -sv gcc /tools/bin/cc

# Check
echo 'int main(){}' > dummy.c
cc dummy.c 
readelf -l a.out | grep ': /tools'
#      [Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2]
rm -v dummy.c a.out

# Clean
cd $LFS/sources/
rm -rf gcc-4.9.2


#
# 5.11. Tcl-8.6.3
#

cd $LFS/sources/
tar xzf tcl8.6.3-src.tar.gz 
cd tcl8.6.3/unix

./configure --prefix=/tools

make

##TZ=UTC make test # no necessary

make install

chmod -v u+w /tools/lib/libtcl8.6.so

make install-private-headers

ln -sv tclsh8.6 /tools/bin/tclsh

which tclsh # for check

# Clean
cd $LFS/sources/
rm -rf tcl8.6.3


#
# 5.12. Expect-5.45
#

cd $LFS/sources/
tar xzf expect5.45.tar.gz
cd expect5.45

cp -v configure{,.orig}
sed 's:/usr/local/bin:/bin:' configure.orig > configure

./configure --prefix=/tools --with-tcl=/tools/lib --with-tclinclude=/tools/include

make
##make test # no necessary
make SCRIPTS="" install

which expect # for check

# Clean
cd $LFS/sources/
rm -rf expect5.45


#
# 5.13. DejaGNU-1.5.2
#

cd $LFS/sources/
tar xzf dejagnu-1.5.2.tar.gz
cd dejagnu-1.5.2

./configure --prefix=/tools

make install
##make check # no necessary

which runtest # check

# Clean
cd $LFS/sources/
rm -rf dejagnu-1.5.2


#
# 5.14. Check-0.9.14
#

cd $LFS/sources/
tar xzf check-0.9.14.tar.gz
cd check-0.9.14

PKG_CONFIG= ./configure --prefix=/tools

make
##make check # no necessary
make install

which checkmk # check

# Clean
cd $LFS/sources/
rm -rf check-0.9.14


#
# 5.15. Ncurses-5.9
#

cd $LFS/sources/
tar xzf ncurses-5.9.tar.gz
cd ncurses-5.9

./configure --prefix=/tools --with-shared --without-debug --without-ada --enable-widec --enable-overwrite

make
make install

# Clean
cd $LFS/sources/
rm -rf ncurses-5.9


#
# 5.16. Bash-4.3.30
#

cd $LFS/sources/
tar xzf bash-4.3.30.tar.gz
cd bash-4.3.30

##patch -p1 < ../bash-4.3.30-upstream_fixes-1.patch 

./configure --prefix=/tools --without-bash-malloc

make
##make tests # no necessary
make install

ln -sv bash /tools/bin/sh

# Clean
cd $LFS/sources/
rm -rf bash-4.3.30


#
# 5.17. Bzip2-1.0.6
#

cd $LFS/sources/
tar xzf bzip2-1.0.6.tar.gz
cd bzip2-1.0.6

##patch -p1 < ../bzip2-1.0.6-install_docs-1.patch

make
make PREFIX=/tools install

which bzip2 # check

# Clean
cd $LFS/sources/
rm -rf bzip2-1.0.6


#
# 5.18. Coreutils-8.23
#

cd $LFS/sources/
tar xJf coreutils-8.23.tar.xz
cd coreutils-8.23

# Donot do this patch
##patch -p1 < ../coreutils-8.23-i18n-1.patch

./configure --prefix=/tools --enable-install-program=hostname

make
##make RUN_EXPENSIVE_TESTS=yes check
make install

# Clean
cd $LFS/sources/
rm -rf coreutils-8.23


#
# 5.19. Diffutils-3.3
#

cd $LFS/sources/
tar xJf diffutils-3.3.tar.xz
cd diffutils-3.3

./configure --prefix=/tools

make
##make check # no necessary
make install

which diff

# Clean
cd $LFS/sources/
rm -rf diffutils-3.3


#
# 5.20. File-5.22
#

cd $LFS/sources/
tar xzf file-5.22.tar.gz 
cd file-5.22

./configure --prefix=/tools

make
##make check
make install

which file

# Clean
cd $LFS/sources/
rm -rf file-5.22


#
# 5.21. Findutils-4.4.2
#

cd $LFS/sources/
tar xzf findutils-4.4.2.tar.gz 
cd findutils-4.4.2

./configure --prefix=/tools

make
##make check
make install

which find

# Clean
cd $LFS/sources/
rm -rf findutils-4.4.2


#
# 5.22. Gawk-4.1.1
#

cd $LFS/sources/
tar xJf gawk-4.1.1.tar.xz 
cd gawk-4.1.1

./configure --prefix=/tools

make
##make check
make install

which gawk

# Clean
cd $LFS/sources/
rm -rf gawk-4.1.1


#
# 5.23. Gettext-0.19.4
#

cd $LFS/sources/
tar xJf gettext-0.19.4.tar.xz 
cd gettext-0.19.4

cd gettext-tools/

EMACS="no" ./configure --prefix=/tools --disable-shared

make -C gnulib-lib
make -C intl pluralx.c
make -C src msgfmt
make -C src msgmerge
make -C src xgettext

cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin

# Clean
cd $LFS/sources/
rm -rf gettext-0.19.4


#
# 5.24. Grep-2.21
#

cd $LFS/sources/
tar xJf grep-2.21.tar.xz 
cd grep-2.21

./configure --prefix=/tools

make
##make check
make install

which grep

# Clean
cd $LFS/sources/
rm -rf grep-2.21


#
# 5.25. Gzip
#

cd $LFS/sources/
tar xJf gzip-1.6.tar.xz 
cd gzip-1.6

./configure --prefix=/tools

make
##make check
make install

which gzip

# Clean
cd $LFS/sources/
rm -rf gzip-1.6


#
# 5.26. M4-1.4.17
#

cd $LFS/sources/
tar xJf m4-1.4.17.tar.xz 
cd m4-1.4.17

./configure --prefix=/tools

make
##make check
make install

which m4

# Clean
cd $LFS/sources/
rm -rf m4-1.4.17


#
# 5.27. Make-4.1
#

cd $LFS/sources/
tar xjf make-4.1.tar.bz2 
cd make-4.1

./configure --prefix=/tools --without-guile

make
##make check
make install

which make

# Clean
cd $LFS/sources/
rm -rf make-4.1


#
# 5.28. Patch-2.7.4
#

cd $LFS/sources/
tar xJf patch-2.7.4.tar.xz 
cd patch-2.7.4

./configure --prefix=/tools

make
##make check
make install

which patch

# Clean
cd $LFS/sources/
rm -rf patch-2.7.4


#
# 5.29. Perl-5.20.2
#

cd $LFS/sources/
tar xjf perl-5.20.2.tar.bz2 
cd perl-5.20.2

sh Configure -des -Dprefix=/tools -Dlibs=-lm

make

cp -v perl cpan/podlators/pod2man /tools/bin
mkdir -pv /tools/lib/perl5/5.20.2
cp -Rv lib/* /tools/lib/perl5/5.20.2

which perl

# Clean
cd $LFS/sources/
rm -rf perl-5.20.2


#
# 5.30. Sed-4.2.2
#

cd $LFS/sources/
tar xjf sed-4.2.2.tar.bz2 
cd sed-4.2.2

./configure --prefix=/tools

make
##make check
make install

which sed

# Clean
cd $LFS/sources/
rm -rf sed-4.2.2


#
# 5.31. Tar-1.28
#

cd $LFS/sources/
tar xJf tar-1.28.tar.xz 
cd tar-1.28

./configure --prefix=/tools

make
##make check
make install

which tar

# Clean
cd $LFS/sources/
rm -rf tar-1.28


#
# 5.32. Texinfo
#

cd $LFS/sources/
tar xJf texinfo-5.2.tar.xz 
cd texinfo-5.2

./configure --prefix=/tools

make
##make check
make install

which makeinfo

# Clean
cd $LFS/sources/
rm -rf texinfo-5.2


#
# 5.33. Util-linux-2.26
#

cd $LFS/sources/
tar xJf util-linux-2.26.tar.xz 
cd util-linux-2.26

./configure --prefix=/tools --without-python --disable-makeinstall-chown --without-systemdsystemunitdir PKG_CONFIG=""

make
make install

# Clean
cd $LFS/sources/
rm -rf util-linux-2.26


#
# 5.34. Xz-5.2.0
#

cd $LFS/sources/
tar xJf xz-5.2.0.tar.xz 
cd xz-5.2.0

./configure --prefix=/tools

make
##make check
make install

# Clean
cd $LFS/sources/
rm -rf xz-5.2.0


#
# 5.35. Stripping
#

# Not necessary, skip it.


#
# 5.36. Changing Ownership
#

# Change the ownership of $LFS/tools/, do it in next part.
#sudo chown -Rv root:root $LFS/tools


#
# 现在我们已经构建好临时工具链，下一步（即 Part III），我们
# 需要以 root 用户重新登录宿主系统并进入 chrooted 环境以构建
# LFS 目标系统（即 LFS_Target_System）。
#

#
# Next
#

cat > $LFS/tf/prompt2enter-next-step.txt << "EOF"
 __       _______     _______.
|  |     |   ____|   /       |
|  |     |  |__     |   (----`
|  |     |   __|     \   \    
|  `----.|  |    .----)   |   
|_______||__|    |_______/    
                              
                              
                              
                              
                              
                              
                              
                              
 ----------------------------
| Please enter Part III.     |
 ----------------------------



EOF
cat $LFS/tf/prompt2enter-next-step.txt 1>&2

# Logout from lfs user and relogin as root user
##sudo reboot


#
# Part III. Building the LFS System (1)
#

#
# Introduction
#

#
# 这一部分，我们开始在 chrooted 环境下构建 LFS_Target_System 基本系统软件。
#
# 0. 首先以 root 用户登录宿主系统，如：
#    ssh root@192.168.56.102 # instead of your own IP address
# 1. 然后进行 mount 操作：
#    sh ~/mount-and-populate.sh
# 2. 最后进入 chrooted 环境：
#    sh ~/chroot2lfs.sh
# 3. 你可以以“sh part-3.1.sh > /tf/building_output.log”的形式构建第6章其余内容，
#    但请体会其构建流程（并且需要查看屏幕是否有致命错误输出）；
# 4. 为了编译的流畅性，在“6.25.3. Setting the root password”暂缓设置 password 
#    而是把它放到本节的最后；
# 5. 为了编译的流畅性，在“6.36. Bash-4.3.30”忽略了登录新编译出来的 bash；
# 6. 如果发现运行 make 时出现“Segmentation fault (core dumped)”错误，请
#    重启宿主系统并执行上述步骤0、1、2，然后重新构建没有完成的系统软件；
# 7. 凡是警告皆可（暂时）忽略，一个错误便要重来，但 Error (ignored) 的可以除外。
# 8. 其实本节应该 make check 或 make test，因为耗时暂且省略。
#    所以你看到类似以下警告就不足为怪了：
#    WARNING: You've never run 'make test'!!!  (Installing anyway.)
# 9. 如果出现不明原因的编译错误，可以 export MAKEFLAGS='-j 1'，
#    再尝试编译看能否解决问题。
# 10.当通过一个终端进入 chrooted 环境进行编译时，就让它静静编译，
#    不要有其他终端重复进入。
#
# 11.在编译“6.66. Man-DB-2.7.1”时，可能出现如下错误：
#make[3]: *** [man.o] Error 1
#make[3]: *** Waiting for unfinished jobs....
#make[2]: *** [all-recursive] Error 1
#make[1]: *** [all-recursive] Error 1
#make: *** [all] Error 2
# 其中，
#make[3]: *** Waiting for unfinished jobs....
# 一般是由于多线程 make 引起的（我们默认是 4 线程 make），如果是这样，
# 用单线程 make 即可解决问题，即：
# make -j1
# 我们的脚本也正是这样做的。
#
# 但还是会出现如下错误：
#man.c:1257:26: error: 'TROFF' undeclared (first use in this function)
#       (get_def ("troff", TROFF));
#
#man.c:1261:26: error: 'NROFF' undeclared (first use in this function)
#       (get_def ("nroff", NROFF));
#                          ^                          ^
#make[3]: *** [man.o] Error 1
#make[2]: *** [all-recursive] Error 1
#make[1]: *** [all-recursive] Error 1
#make: *** [all] Error 2
#......
#make: *** [install-recursive] Error 1
# 这正是同学们大显身手解决问题的好机会：）
# 然而如果忽略以上错误，对构建 LFS 目标系统的流程不会造成影响，
# 即不会导致 LFS 目标系统构建不下去的现象。
#

#
# Chapter 6. Installing Basic System Software
#

# Set an environment variable to tell the make program 
# that how many processors are available
#
export MAKEFLAGS='-j 4'
echo $MAKEFLAGS 1>&2
#-j 4
# 这里是 4 核，你的情况可能与此不同。

#
# 6.7. Linux-3.19 API Headers
#

cd /sources
tar xJf linux-3.19.tar.xz
cd linux-3.19

make mrproper # check-point for make error: Segmentation fault (core dumped)
make INSTALL_HDR_PATH=dest headers_install
find dest/include \( -name .install -o -name ..install.cmd \) -delete
cp -rv dest/include/* /usr/include

# Clean
cd /sources/
rm -rf linux-3.19


# 6.8. Man-pages-3.79

cd /sources
tar xJf man-pages-3.79.tar.xz
cd man-pages-3.79

make install

# Clean
cd /sources/
rm -rf man-pages-3.79


# 6.9. Glibc-2.21

cd /sources
tar xJf glibc-2.21.tar.xz
cd glibc-2.21

# 6.9.1. Installation of Glibc

patch -Np1 -i ../glibc-2.21-fhs-1.patch

sed -e '/ia32/s/^/1:/' -e '/SSE2/s/^1://' -i sysdeps/i386/i686/multiarch/mempcpy_chk.S

mkdir build
cd build/

../configure --prefix=/usr --disable-profile --enable-kernel=2.6.32 --enable-obsolete-rpc

make
##make check # Do it!

touch /etc/ld.so.conf
make install

cp -v /sources/glibc-2.21/nscd/nscd.conf /etc/nscd.conf
mkdir -pv /var/cache/nscd

install -v -Dm644 ../nscd/nscd.tmpfiles /usr/lib/tmpfiles.d/nscd.conf
install -v -Dm644 ../nscd/nscd.service /lib/systemd/system/nscd.service

make localedata/install-locales


# 6.9.2. Configuring Glibc

cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf
passwd: files
group: files
shadow: files
hosts: files dns myhostname
networks: files
protocols: files
services: files
ethers: files
rpc: files
# End /etc/nsswitch.conf
EOF

cd ..
tar -xf ../tzdata2015a.tar.gz

cat > install-timezone-data.sh << "EOF"
#!/bin/bash

ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}
for tz in etcetera southamerica northamerica europe africa antarctica asia australasia backward pacificnew systemv; do
zic -L /dev/null -d $ZONEINFO -y "sh yearistype.sh" ${tz}
zic -L /dev/null -d $ZONEINFO/posix -y "sh yearistype.sh" ${tz}
zic -L leapseconds -d $ZONEINFO/right -y "sh yearistype.sh" ${tz}
done
cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York
unset ZONEINFO
EOF

sh install-timezone-data.sh

##tzselect
#  Need to answer a few questions about the location

# And the result is:
ln -sfv /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 6.9.3. Configuring the Dynamic Loader
cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib
EOF

cat >> /etc/ld.so.conf << "EOF"
# Add an include directory
include /etc/ld.so.conf.d/*.conf
EOF

mkdir -pv /etc/ld.so.conf.d

# Clean
cd /sources/
rm -rf glibc-2.21


#
# 6.10. Adjusting the Toolchain
#

mv -v /tools/bin/{ld,ld-old}
mv -v /tools/$(gcc -dumpmachine)/bin/{ld,ld-old}
mv -v /tools/bin/{ld-new,ld}
ln -sv /tools/bin/ld /tools/$(gcc -dumpmachine)/bin/ld

gcc -dumpspecs | sed -e 's@/tools@@g' -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' > `dirname $(gcc --print-libgcc-file-name)`/specs

echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'

grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
grep -B1 '^ /usr/include' dummy.log
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
grep "/lib.*/libc.so.6 " dummy.log
grep found dummy.log

rm -v dummy.c a.out dummy.log


#
# 6.11. Zlib-1.2.8
#

cd /sources
tar xJf zlib-1.2.8.tar.xz
cd zlib-1.2.8

./configure --prefix=/usr
make
##make check # Do it!
make install

mv -v /usr/lib/libz.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so

# Clean
cd /sources/
rm -rf zlib-1.2.8

#
# 6.12. File-5.22
#

cd /sources
tar xzf file-5.22.tar.gz
cd file-5.22

./configure --prefix=/usr
make
##make check # Do it!
make install

# Clean
cd /sources/
rm -rf file-5.22

#
# 6.13. Binutils-2.25
#

cd /sources
tar xjf binutils-2.25.tar.bz2
cd binutils-2.25
expect -c "spawn ls"
  
mkdir build
cd build

../configure --prefix=/usr --enable-shared --disable-werror
make tooldir=/usr
##make -k check # Do it!
make tooldir=/usr install

# Clean
cd /sources/
rm -rf binutils-2.25

#
# 6.14. GMP-6.0.0a
#

cd /sources
tar xJf gmp-6.0.0a.tar.xz
cd gmp-6.0.0

./configure --prefix=/usr --enable-cxx --docdir=/usr/share/doc/gmp-6.0.0a
make
make html

# Do it begin
##make check 2>&1 | tee gmp-check-log
##awk '/tests passed/{total+=$2} ; END{print total}' gmp-check-log
# Do it end.

make install
make install-html

# Clean
cd /sources/
rm -rf gmp-6.0.0


#
# 6.15. MPFR-3.1.2
#

cd /sources
tar xJf mpfr-3.1.2.tar.xz
cd mpfr-3.1.2

patch -Np1 -i ../mpfr-3.1.2-upstream_fixes-3.patch
./configure --prefix=/usr --enable-thread-safe --docdir=/usr/share/doc/mpfr-3.1.2
make
make html
##make check # Do it!
make install
make install-html

# Clean
cd /sources/
rm -rf mpfr-3.1.2


#
# 6.16. MPC-1.0.2
#

cd /sources
tar xzf mpc-1.0.2.tar.gz
cd mpc-1.0.2

./configure --prefix=/usr --docdir=/usr/share/doc/mpc-1.0.2
make
make html
##make check # Do it!
make install
make install-html

# Clean
cd /sources/
rm -rf mpc-1.0.2


#
# 6.17. GCC-4.9.2
#

cd /sources
tar xjf gcc-4.9.2.tar.bz2
cd gcc-4.9.2

cp /cfns-4.9.2.patch ./
patch -p1 < cfns-4.9.2.patch

mkdir build
cd build

SED=sed ../configure --prefix=/usr --enable-languages=c,c++ --disable-multilib --disable-bootstrap --with-system-zlib

make

# Do it begin
##ulimit -s 32768
##make -k check
##../contrib/test_summary
##../contrib/test_summary | grep -A7 Summ
# Do it end.

make install

ln -sv /usr/bin/cpp /lib
ln -sv gcc /usr/bin/cc

install -v -dm755 /usr/lib/bfd-plugins
ln -sfv /usr/libexec/gcc/$(gcc -dumpmachine)/4.9.2/liblto_plugin.so /usr/lib/bfd-plugins/

echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
#      [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]

grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
grep -B4 '^ /usr/include' dummy.log
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
grep "/lib.*/libc.so.6 " dummy.log
grep found dummy.log
#  found ld-linux-x86-64.so.2 at /lib64/ld-linux-x86-64.so.2

rm -v dummy.c a.out dummy.log # no necessary

mkdir -pv /usr/share/gdb/auto-load/usr/lib
##ls /usr/lib/*gdb.py
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib

# Clean
cd /sources/
rm -rf gcc-4.9.2


#
# 6.18. Bzip2-1.0.6
#

cd /sources
tar xzf bzip2-1.0.6.tar.gz
cd bzip2-1.0.6

patch -Np1 -i ../bzip2-1.0.6-install_docs-1.patch

sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

make -f Makefile-libbz2_so
make clean
make
make PREFIX=/usr install

cp -v bzip2-shared /bin/bzip2
cp -av libbz2.so* /lib
ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so
rm -v /usr/bin/{bunzip2,bzcat,bzip2}
ln -sv bzip2 /bin/bunzip2
ln -sv bzip2 /bin/bzcat

# Clean
cd /sources/
rm -rf bzip2-1.0.6


#
# 6.19. Pkg-config-0.28
#

cd /sources
tar xzf pkg-config-0.28.tar.gz
cd pkg-config-0.28

./configure --prefix=/usr --with-internal-glib --disable-host-tool --docdir=/usr/share/doc/pkg-config-0.28

make
##make check # Do it!
make install

# Clean
cd /sources/
rm -rf pkg-config-0.28


#
# 6.20. Ncurses-5.9
#

cd /sources
tar xzf ncurses-5.9.tar.gz
cd ncurses-5.9

./configure --prefix=/usr --mandir=/usr/share/man --with-shared --without-debug --enable-pc-files --enable-widec

make
make install

mv -v /usr/lib/libncursesw.so.5* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) /usr/lib/libncursesw.so

cat > ncurses4app.sh << "EOF"
#!/bin/bash

for lib in ncurses form panel menu ; do
rm -vf /usr/lib/lib${lib}.so
echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
ln -sfv lib${lib}w.a /usr/lib/lib${lib}.a
ln -sfv ${lib}w.pc /usr/lib/pkgconfig/${lib}.pc
done
ln -sfv libncurses++w.a /usr/lib/libncurses++.a
EOF

sh ncurses4app.sh

rm -vf /usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
ln -sfv libncurses.so /usr/lib/libcurses.so
ln -sfv libncursesw.a /usr/lib/libcursesw.a
ln -sfv libncurses.a /usr/lib/libcurses.a

mkdir -v /usr/share/doc/ncurses-5.9
cp -v -R doc/* /usr/share/doc/ncurses-5.9

# Clean
cd /sources/
rm -rf ncurses-5.9


#
# 6.21. Attr-2.4.47
#

cd /sources
tar xzf attr-2.4.47.src.tar.gz
cd attr-2.4.47

sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
sed -i -e "/SUBDIRS/s|man2||" man/Makefile

./configure --prefix=/usr

make
##make -j1 tests root-tests # 29 commands (14 passed, 15 failed)

make install install-dev install-lib
chmod -v 755 /usr/lib/libattr.so

mv -v /usr/lib/libattr.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so

# Clean
cd /sources/
rm -rf attr-2.4.47


#
# 6.22. Acl-2.2.52
#

cd /sources
tar xzf acl-2.2.52.src.tar.gz
cd acl-2.2.52

sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
sed -i "s:| sed.*::g" test/{sbits-restore,cp,misc}.test
sed -i -e "/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);" libacl/__acl_to_any_text.c

./configure --prefix=/usr --libexecdir=/usr/lib

make

##make -j1 tests # Note: When coreutils have built # Do it!

make install install-dev install-lib
chmod -v 755 /usr/lib/libacl.so

mv -v /usr/lib/libacl.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so

# Clean
cd /sources/
rm -rf acl-2.2.52


#
# 6.23. Libcap-2.24
#

cd /sources
tar xJf libcap-2.24.tar.xz
cd libcap-2.24

make

make RAISE_SETFCAP=no prefix=/usr install
chmod -v 755 /usr/lib/libcap.so

mv -v /usr/lib/libcap.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so

# Clean
cd /sources/
rm -rf libcap-2.24


#
# 6.24. Sed-4.2.2
#

cd /sources
tar xjf sed-4.2.2.tar.bz2
cd sed-4.2.2

./configure --prefix=/usr --bindir=/bin --htmldir=/usr/share/doc/sed-4.2.2

make
make html
##make check # Do it!
make install
make -C doc install-html

# Clean
cd /sources/
rm -rf sed-4.2.2


#
# 6.25. Shadow-4.2.1
#

# 6.25.1. Installation of Shadow

cd /sources
tar xJf shadow-4.2.1.tar.xz
cd shadow-4.2.1

sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /' {} \;

sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' -e 's@/var/spool/mail@/var/mail@' etc/login.defs

sed -i 's/1000/999/' etc/useradd

./configure --sysconfdir=/etc --with-group-name-max-length=32

make
make install
mv -v /usr/bin/passwd /bin

# 6.25.2. Configuring Shadow

# To enable shadowed passwords and group passwords:
pwconv
grpconv

# If you would prefer that the mailbox files are not created by useradd:
sed -i 's/yes/no/' /etc/default/useradd

# 6.25.3. Setting the root password
#passwd root # by inputing handy, but no necessary.
#  Changing password for root
#  Enter the new password (minimum of 5 characters)
#  Please use a combination of upper and lower case letters and numbers.
#  New password:
#  Re-enter new password:
#  passwd: password changed.

# Clean
cd /sources/
rm -rf shadow-4.2.1


#
# 6.26. Psmisc-22.21
#

cd /sources
tar xzf psmisc-22.21.tar.gz
cd psmisc-22.21

./configure --prefix=/usr

make
make install
mv -v /usr/bin/fuser /bin
mv -v /usr/bin/killall /bin

# Clean
cd /sources/
rm -rf psmisc-22.21


#
# 6.27. Procps-ng-3.3.10
#

cd /sources
tar xJf procps-ng-3.3.10.tar.xz
cd procps-ng-3.3.10

./configure --prefix=/usr --exec-prefix= --libdir=/usr/lib --docdir=/usr/share/doc/procps-ng-3.3.10 --disable-static --disable-kill

make

# The test suite needs some custom modifications:
##sed -i -r 's|(pmap_initname)\\\$|\1|' testsuite/pmap.test/pmap.exp
##make check

make install
mv -v /usr/bin/pidof /bin
mv -v /usr/lib/libprocps.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libprocps.so) /usr/lib/libprocps.so

# Clean
cd /sources/
rm -rf procps-ng-3.3.10


#
# 6.28. E2fsprogs-1.42.12
#

cd /sources
tar xzf e2fsprogs-1.42.12.tar.gz
cd e2fsprogs-1.42.12

sed -e '/int.*old_desc_blocks/s/int/blk64_t/' -e '/if (old_desc_blocks/s/super->s_first_meta_bg/desc_blocks/' -i lib/ext2fs/closefs.c
mkdir build
cd build

LIBS=-L/tools/lib CFLAGS=-I/tools/include PKG_CONFIG_PATH=/tools/lib/pkgconfig ../configure --prefix=/usr --bindir=/bin --with-root-prefix="" --enable-elf-shlibs --disable-libblkid --disable-libuuid --disable-uuidd --disable-fsck

make

# To set up and run the test suite we need to first link some libraries 
# from /tools/lib to a location where the test programs look:
##ln -sfv /tools/lib/lib{blk,uu}id.so.1 lib
##make LD_LIBRARY_PATH=/tools/lib check # Do it!

make install
make install-libs

chmod -v u+w /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a

gunzip -v /usr/share/info/libext2fs.info.gz
install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info

makeinfo -o doc/com_err.info ../lib/et/com_err.texinfo
install -v -m644 doc/com_err.info /usr/share/info
install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info

# Clean
cd /sources/
rm -rf e2fsprogs-1.42.12


#
# 6.29. Coreutils-8.23
#

cd /sources
tar xJf coreutils-8.23.tar.xz
cd coreutils-8.23

patch -Np1 -i ../coreutils-8.23-i18n-1.patch
touch Makefile.in

FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr --enable-no-install-program=kill,uptime
make 

# Do it begin
##make NON_ROOT_USERNAME=nobody check-root
##echo "dummy:x:1000:nobody" >> /etc/group
##chown -Rv nobody .
##su nobody -s /bin/bash -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check"
##sed -i '/dummy/d' /etc/group
# Do it end.

make install

mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin
mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin
mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8

mv -v /usr/bin/{head,sleep,nice,test,[} /bin

# Clean
cd /sources/
rm -rf coreutils-8.23


#
# 6.30. Iana-Etc-2.30
#

cd /sources
tar xjf iana-etc-2.30.tar.bz2
cd iana-etc-2.30

make
make install

# Clean
cd /sources/
rm -rf iana-etc-2.30


#
# 6.31. M4-1.4.17
#

cd /sources
tar xJf m4-1.4.17.tar.xz
cd m4-1.4.17

./configure --prefix=/usr

make
##make check # Do it!
make install

# Clean
cd /sources/
rm -rf m4-1.4.17


#
# 6.32. Flex-2.5.39
#

cd /sources
tar xjf flex-2.5.39.tar.bz2
cd flex-2.5.39

sed -i -e '/test-bison/d' tests/Makefile.in
./configure --prefix=/usr --docdir=/usr/share/doc/flex-2.5.39

make
##make check # Do it!
make install

ln -sv flex /usr/bin/lex

# Clean
cd /sources/
rm -rf flex-2.5.39


#
# 6.33. Bison-3.0.4
#

cd /sources
tar xJf bison-3.0.4.tar.xz
cd bison-3.0.4

./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.0.4

make
##make check # Do it!
make install

# Clean
cd /sources/
rm -rf bison-3.0.4


#
# 6.34. Grep-2.21
#

cd /sources
tar xJf grep-2.21.tar.xz
cd grep-2.21

sed -i -e '/tp++/a if (ep <= tp) break;' src/kwset.c

./configure --prefix=/usr --bindir=/bin

make
##make check # Do it!
make install

# Clean
cd /sources/
rm -rf grep-2.21


#
# 6.35. Readline-6.3
#

cd /sources
tar xzf readline-6.3.tar.gz
cd readline-6.3

patch -Np1 -i ../readline-6.3-upstream_fixes-3.patch

sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install
./configure --prefix=/usr --docdir=/usr/share/doc/readline-6.3

make SHLIB_LIBS=-lncurses
make SHLIB_LIBS=-lncurses install

mv -v /usr/lib/lib{readline,history}.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so
ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so

install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-6.3

# Clean
cd /sources/
rm -rf readline-6.3


# 6.36. Bash-4.3.30

cd /sources
tar xzf bash-4.3.30.tar.gz
cd bash-4.3.30

patch -Np1 -i ../bash-4.3.30-upstream_fixes-1.patch

./configure --prefix=/usr --bindir=/bin --docdir=/usr/share/doc/bash-4.3.30 --without-bash-malloc --with-installed-readline

make

# Do it begin
# To prepare the tests, ensure that the nobody user can write to the sources tree:
##chown -Rv nobody .
##su nobody -s /bin/bash -c "PATH=$PATH make tests"
# Do it end.

make install

# Run the newly compiled bash program (replacing the one that is currently being executed):
#exec /bin/bash --login +h
# Ignore it!

# Clean
cd /sources/
rm -rf bash-4.3.30


# 6.37. Bc-1.06.95

cd /sources
tar xjf bc-1.06.95.tar.bz2
cd bc-1.06.95

patch -Np1 -i ../bc-1.06.95-memory_leak-1.patch

./configure --prefix=/usr --with-readline --mandir=/usr/share/man --infodir=/usr/share/info

make

# To test bc, run the commands below:
##echo "quit" | ./bc/bc -l Test/checklib.b

make install

# Clean
cd /sources/
rm -rf bc-1.06.95


# 6.38. Libtool-2.4.6

cd /sources
tar xJf libtool-2.4.6.tar.xz
cd libtool-2.4.6

./configure --prefix=/usr

make
##make check # 5 failures before installing automake # Do it!
make install

# Clean
cd /sources/
rm -rf libtool-2.4.6


# 6.39. GDBM-1.11

cd /sources
tar xzf gdbm-1.11.tar.gz
cd gdbm-1.11

./configure --prefix=/usr --enable-libgdbm-compat

make
##make check # Do it!
make install

# Clean
cd /sources/
rm -rf gdbm-1.11


# 6.40. Expat-2.1.0

cd /sources
tar xzf expat-2.1.0.tar.gz
cd expat-2.1.0

./configure --prefix=/usr

make
##make check # Do it!
make install
  
install -v -dm755 /usr/share/doc/expat-2.1.0
install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.1.0

# Clean
cd /sources/
rm -rf expat-2.1.0


# 6.41. Inetutils-1.9.2

cd /sources
tar xzf inetutils-1.9.2.tar.gz
cd inetutils-1.9.2

echo '#define PATH_PROCNET_DEV "/proc/net/dev"' >> ifconfig/system/linux.h

./configure --prefix=/usr --localstatedir=/var --disable-logger --disable-whois --disable-servers

make
##make check # Do it!
make install

mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin
mv -v /usr/bin/ifconfig /sbin

# Clean
cd /sources/
rm -rf inetutils-1.9.2


# 6.42. Perl-5.20.2

cd /sources
tar xjf perl-5.20.2.tar.bz2
cd perl-5.20.2

echo "127.0.0.1 localhost $(hostname)" > /etc/hosts

export BUILD_ZLIB=False
export BUILD_BZIP2=0

sh Configure -des -Dprefix=/usr -Dvendorprefix=/usr -Dman1dir=/usr/share/man/man1 -Dman3dir=/usr/share/man/man3 -Dpager="/usr/bin/less -isR" -Duseshrplib

make

##make -k test # Do it!

make install
unset BUILD_ZLIB BUILD_BZIP2

# Clean
cd /sources/
rm -rf perl-5.20.2


# 6.43. XML::Parser-2.44

cd /sources
tar xzf XML-Parser-2.44.tar.gz
cd XML-Parser-2.44

perl Makefile.PL

make
##make test # Do it!
make install

# Clean
cd /sources/
rm -rf XML-Parser-2.44


# 6.44. Autoconf-2.69

cd /sources
tar xJf autoconf-2.69.tar.xz
cd autoconf-2.69

./configure --prefix=/usr

make
##make check # One test fails due to changes in libtool-2.4.3 and later.
make install

# Clean
cd /sources/
rm -rf autoconf-2.69


# 6.45. Automake-1.15

cd /sources
tar xJf automake-1.15.tar.xz
cd automake-1.15

./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.15

make

sed -i "s:./configure:LEXLIB=/usr/lib/libfl.a &:" t/lex-{clean,depend}-cxx.sh
##make -j4 check

make install

# Clean
cd /sources/
rm -rf automake-1.15


# 6.46. Diffutils-3.3

cd /sources
tar xJf diffutils-3.3.tar.xz
cd diffutils-3.3

sed -i 's:= @mkdir_p@:= /bin/mkdir -p:' po/Makefile.in.in
./configure --prefix=/usr

make
##make check
make install

# Clean
cd /sources/
rm -rf diffutils-3.3


# 6.47. Gawk-4.1.1

cd /sources
tar xJf gawk-4.1.1.tar.xz
cd gawk-4.1.1

./configure --prefix=/usr

make
##make check
make install

# If desired, install the documentation:
mkdir -v /usr/share/doc/gawk-4.1.1
cp -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-4.1.1

# Clean
cd /sources/
rm -rf gawk-4.1.1


# 6.48. Findutils-4.4.2

cd /sources
tar xzf findutils-4.4.2.tar.gz
cd findutils-4.4.2

./configure --prefix=/usr --localstatedir=/var/lib/locate

make
##make check # optimize the source code to dispaly green "PASS"
make install

# Clean
cd /sources/
rm -rf findutils-4.4.2


# 6.49. Gettext-0.19.4

cd /sources
tar xJf gettext-0.19.4.tar.xz
cd gettext-0.19.4

./configure --prefix=/usr --docdir=/usr/share/doc/gettext-0.19.4

make
##make check
make install

# Clean
cd /sources/
rm -rf gettext-0.19.4


# 6.50. Intltool-0.50.2

cd /sources
tar xzf intltool-0.50.2.tar.gz
cd intltool-0.50.2

./configure --prefix=/usr

make
##make check
make install
install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.50.2/I18NHOWTO

# Clean
cd /sources/
rm -rf intltool-0.50.2


# 6.51. Gperf-3.0.4

cd /sources
tar xzf gperf-3.0.4.tar.gz
cd gperf-3.0.4

./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.0.4

make
##make check
make install

# Clean
cd /sources/
rm -rf gperf-3.0.4


# 6.52. Groff-1.22.3

cd /sources
tar xzf groff-1.22.3.tar.gz
cd groff-1.22.3

PAGE=letter ./configure --prefix=/usr

make
make install

# Clean
cd /sources/
rm -rf groff-1.22.3


# 6.53. Xz-5.2.0

cd /sources
tar xJf xz-5.2.0.tar.xz
cd xz-5.2.0

./configure --prefix=/usr --docdir=/usr/share/doc/xz-5.2.0

make

##make check

# Install the package and make sure that all essential files are in the correct directory:

make install
mv -v /usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} /bin
mv -v /usr/lib/liblzma.so.* /lib
# Warning: Do not copy Chinese edition LFS-BOOK for this command due to full-width brackets
ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so

# Clean
cd /sources/
rm -rf xz-5.2.0


# 6.54. GRUB-2.02~beta2

cd /sources
tar xJf grub-2.02~beta2.tar.xz
cd grub-2.02~beta2

./configure --prefix=/usr --sbindir=/sbin --sysconfdir=/etc --disable-grub-emu-usb --disable-efiemu --disable-werror

make
make install

# Clean
cd /sources/
rm -rf grub-2.02~beta2


# 6.55. Less-458

cd /sources
tar xzf less-458.tar.gz
cd less-458

./configure --prefix=/usr --sysconfdir=/etc

make
make install

# Clean
cd /sources/
rm -rf less-458


# 6.56. Gzip-1.6

cd /sources
tar xJf gzip-1.6.tar.xz
cd gzip-1.6

./configure --prefix=/usr --bindir=/bin

make
##make check
make install

mv -v /bin/{gzexe,uncompress,zcmp,zdiff,zegrep} /usr/bin
mv -v /bin/{zfgrep,zforce,zgrep,zless,zmore,znew} /usr/bin

# Clean
cd /sources/
rm -rf gzip-1.6


# 6.57. IPRoute2-3.19.0

cd /sources
tar xJf iproute2-3.19.0.tar.xz
cd iproute2-3.19.0

sed -i '/^TARGETS/s@arpd@@g' misc/Makefile
sed -i /ARPD/d Makefile
sed -i 's/arpd.8//' man/man8/Makefile

make
make DOCDIR=/usr/share/doc/iproute2-3.19.0 install

# Clean
cd /sources/
rm -rf iproute2-3.19.0


# 6.58. Kbd-2.0.2

cd /sources
tar xzf kbd-2.0.2.tar.gz
cd kbd-2.0.2

patch -Np1 -i ../kbd-2.0.2-backspace-1.patch

# Warning: Do not copy Chinese edition LFS-BOOK for this command due to full-width brackets
sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr --disable-vlock

make
##make check
make install

mkdir -v /usr/share/doc/kbd-2.0.2
cp -R -v docs/doc/* /usr/share/doc/kbd-2.0.2

# Clean
cd /sources/
rm -rf kbd-2.0.2


# 6.59. Kmod-19

cd /sources
tar xJf kmod-19.tar.xz
cd kmod-19

./configure --prefix=/usr --bindir=/bin --sysconfdir=/etc --with-rootlibdir=/lib --with-xz --with-zlib

make
##make check
make install

cat > module-init-tools.sh << "EOF"
#!/bin/bash

for target in depmod insmod lsmod modinfo modprobe rmmod; do
ln -sv ../bin/kmod /sbin/$target
done
ln -sv kmod /bin/lsmod
EOF

sh module-init-tools.sh

# Clean
cd /sources/
rm -rf kmod-19


# 6.60. Libpipeline-1.4.0

cd /sources
tar xzf libpipeline-1.4.0.tar.gz
cd libpipeline-1.4.0

PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr

make
##make check
make install

# Clean
cd /sources/
rm -rf libpipeline-1.4.0


# 6.61. Make-4.1

cd /sources
tar xjf make-4.1.tar.bz2
cd make-4.1

./configure --prefix=/usr

make
##make check
make install

# Clean
cd /sources/
rm -rf make-4.1


# 6.62. Patch-2.7.4

cd /sources
tar xJf patch-2.7.4.tar.xz
cd patch-2.7.4

./configure --prefix=/usr

make
##make check
make install

# Clean
cd /sources/
rm -rf patch-2.7.4


# 6.63. Systemd-219

cd /sources
tar xJf systemd-219.tar.xz
cd systemd-219

# First, create a file to allow systemd to build when using Util-Linux built 
# in Chapter 5 and disable LTO by default:
cat > config.cache << "EOF"
KILL=/bin/kill
HAVE_BLKID=1
BLKID_LIBS="-lblkid"
BLKID_CFLAGS="-I/tools/include/blkid"
HAVE_LIBMOUNT=1
MOUNT_LIBS="-lmount"
MOUNT_CFLAGS="-I/tools/include/libmount"
cc_cv_CFLAGS__flto=no
EOF

# Additionally, fix a build error when using Util-Linux built in Chapter 5:
# Warning: Do not copy Chinese edition LFS-BOOK for this command due to full-width brackets
sed -i "s:blkid/::" $(grep -rl "blkid/blkid.h")

# Apply the following patch so that compat pkg-config files get installed 
# without installing compat libs which are useless on LFS:
patch -Np1 -i ../systemd-219-compat-1.patch

# Disable a test case that always fails:
sed -i "s:test/udev-test.pl ::g" Makefile.in

# Prepare systemd for compilation:
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --config-cache --with-rootprefix= --with-rootlibdir=/lib --enable-split-usr --disable-gudev --disable-firstboot --disable-ldconfig --disable-sysusers --without-python --docdir=/usr/share/doc/systemd-219 --with-dbuspolicydir=/etc/dbus-1/system.d --with-dbussessionservicedir=/usr/share/dbus-1/services --with-dbussystemservicedir=/usr/share/dbus-1/system-services

# Compile the package:
make LIBRARY_PATH=/tools/lib

# Install the package:
make LD_LIBRARY_PATH=/tools/lib install

# Move NSS libraries to /lib:
mv -v /usr/lib/libnss_{myhostname,mymachines,resolve}.so.2 /lib

# Remove an unnecessary directory:
rm -rfv /usr/lib/rpm

# Create the Sysvinit compatibility symlinks, so systemd is used as the default init system:
cat > sysvinit-compatibility.sh << "EOF"
#!/bin/bash

for tool in runlevel reboot shutdown poweroff halt telinit; do
ln -sfv ../bin/systemctl /sbin/${tool}
done
ln -sfv ../lib/systemd/systemd /sbin/init
EOF

sh sysvinit-compatibility.sh

# Remove a reference to a non-existent group and fix a configuration file 
# so it doesn't cause systemd-tmpfiles to fail at boot:
sed -i "s:0775 root lock:0755 root root:g" /usr/lib/tmpfiles.d/legacy.conf
sed -i "/pam.d/d" /usr/lib/tmpfiles.d/etc.conf

# Create the /etc/machine-id file needed by systemd-journald:
systemd-machine-id-setup
#  Initializing machine ID from KVM UUID.

# To test the results, issue:
##sed -i "s:minix:ext4:g" src/test/test-path-util.c
##make LD_LIBRARY_PATH=/tools/lib -k check

# Clean
cd /sources/
rm -rf systemd-219


# 6.64. D-Bus-1.8.16

cd /sources
tar xzf dbus-1.8.16.tar.gz
cd dbus-1.8.16

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --docdir=/usr/share/doc/dbus-1.8.16 --with-console-auth-dir=/run/console

make
make install

# The shared library:
mv -v /usr/lib/libdbus-1.so.* /lib
# Warning: Do not copy Chinese edition LFS-BOOK for this command due to full-width brackets
ln -sfv ../../lib/$(readlink /usr/lib/libdbus-1.so) /usr/lib/libdbus-1.so

# Create a symlink, so that D-Bus and systemd can use the same machine-id file:
ln -sfv /etc/machine-id /var/lib/dbus

# Clean
cd /sources/
rm -rf dbus-1.8.16


# 6.65. Util-linux-2.26

cd /sources
tar -xJf util-linux-2.26.tar.xz
cd util-linux-2.26

mkdir -pv /var/lib/hwclock

./configure ADJTIME_PATH=/var/lib/hwclock/adjtime --docdir=/usr/share/doc/util-linux-2.26 --disable-chfn-chsh --disable-login --disable-nologin --disable-su --disable-setpriv --disable-runuser --disable-pylibmount --without-python

make
make install

# Clean
cd /sources/
rm -rf util-linux-2.26


# 6.66. Man-DB-2.7.1

cd /sources
tar xJf man-db-2.7.1.tar.xz
cd man-db-2.7.1

./configure --prefix=/usr --docdir=/usr/share/doc/man-db-2.7.1 --sysconfdir=/etc --disable-setuid --with-browser=/usr/bin/lynx --with-vgrind=/usr/bin/vgrind --with-grap=/usr/bin/grap

make -j1
##make -j1 check
make -j1 install

sed -i "s:man root:root root:g" /usr/lib/tmpfiles.d/man-db.conf

# Clean
cd /sources/
rm -rf man-db-2.7.1


# 6.67. Tar-1.28

cd /sources
tar xJf tar-1.28.tar.xz
cd tar-1.28

FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr --bindir=/bin

make
##make check

# Install the package:
make install
make -C doc install-html docdir=/usr/share/doc/tar-1.28

# Clean
cd /sources/
rm -rf tar-1.28


# 6.68. Texinfo-5.2

cd /sources
tar xJf texinfo-5.2.tar.xz
cd texinfo-5.2

./configure --prefix=/usr

##make check
make install

make TEXMF=/usr/share/texmf install-tex

# Clean
cd /sources/
rm -rf texinfo-5.2


# 6.69. Vim-7.4

# 6.69.1. Installation of Vim

cd /sources
tar xjf vim-7.4.tar.bz2
cd vim74/

echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h

./configure --prefix=/usr
make
##make -j1 test
make install

# Ignoring begin 
##cat > vim4vi.sh << "EOF"
##ln -sv vim /usr/bin/vi
##for L in /usr/share/man/{,*/}man1/vim.1; do
##ln -sv vim.1 $(dirname $L)/vi.1
##done
##EOF
##sh vim4vi.sh
# Ignoring end

# By default, Vim's documentation is installed in /usr/share/vim. The following symlink allows the documentation
# to be accessed via /usr/share/doc/vim-7.4, making it consistent with the location of documentation for other
# packages:
ln -sv ../vim/vim74/doc /usr/share/doc/vim-7.4

# 6.69.2. Configuring Vim

# Configuring Vim
cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

set nocompatible
set backspace=2
syntax on
if (&term == "iterm") || (&term == "putty")
    set background=dark
endif

" End /etc/vimrc
EOF

# Documentation for other available options can be obtained 
# by running the following command:
##vim -c ':options'

# Clean
cd /sources/
rm -rf vim74

# 6.70. About Debugging Symbols and Stripping

# 6.71. Stripping Again
# Ignore this stripping.

# 6.72. Cleaning Up
# Ignore this step.



#
# 现在我们已经为 LFS_Target_System 编译并安装好了
# 基本的系统软件，现在我们重启宿主系统，重新以 root 
# 身份登录对 LFS 目标系统做一些配置并使其可引导。
#

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
| Please set password        |
| before                     |
| entering part-3.2.         |
 ----------------------------



EOF
cat /tf/prompt2enter-next-step.txt 1>&2

# Before entering next section, you can sett the root password
##passwd root # by inputing handy
# For instance: Lfs12#$

#exit
#reboot # and login by root user






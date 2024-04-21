# ARM toolschain example

# @x64-VM

yum groupinstall "Development tools" -y

mkdir /usr/local/arm-toolchain
cd /usr/local/arm-toolchain/

wget https://releases.linaro.org/components/toolchain/binaries/latest-7/aarch64-linux-gnu/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu.tar.xz
tar -xvf gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu.tar.xz

cp /etc/profile{,.origin}
echo "export PATH=$PATH:/usr/local/arm-toolchain/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/bin" >> /etc/profile

source /etc/profile

aarch64-linux-gnu-gcc -v

cat > ./hello.c << "EOF"
#include <stdio.h>

int main()
{
	printf("Hello, Kunpeng!\n");
	return 0;
}
EOF

aarch64-linux-gnu-gcc hello.c -o hello-kp
gcc hello.c -o hello

./hello-kp # -bash: ./hello-kp: cannot execute binary file: Exec format error
./hello    # Hello, Kunpeng!

file hello-kp # hello-kp: ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux-aarch64.so.1, for GNU/Linux 3.7.0, BuildID[sha1]=ae4f043accb84267c56046703de47baa5a6ec36e, with debug_info, not stripped
file hello    #    hello: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=a1b18c4fcc6476036674e879d88533e650c692eb, for GNU/Linux 3.2.0, not stripped

scp {hello,hello-kp} root@121.1.2.3:/root/ # Note: Instead of your IP address here

#-------------------------------------------------------------------------------

# @Kunpeng-VM

cd ~

chmod +x hello-kp
chmod +x hello

./hello-kp # Hello, Kunpeng!
./hello    # -bash: ./hello: cannot execute binary file: Exec format error


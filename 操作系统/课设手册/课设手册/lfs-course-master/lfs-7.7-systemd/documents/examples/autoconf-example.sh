
# The instance of building sed with GNU autoconf

cd ~
mkdir ~/build-sed && cd $_

##wget http://mirrors.ustc.edu.cn/gnu/sed/sed-4.2.2.tar.gz
wget https://ftp.gnu.org/gnu/sed/sed-4.2.2.tar.gz
tar xzf sed-4.2.2.tar.gz
cd sed-4.2.2

./configure --prefix=$HOME/mysed

make
ls -l sed/
#...
#-rwx------ 1 root root 283456 Jan 11 16:43 sed

make check

make -n install # test install
make install

cd ~
ls -l ~/mysed/bin/
#total 280
#-rwxr-xr-x 1 root root 283456 Jan 11 16:45 sed

echo "This is a test" | ~/mysed/bin/sed 's/test/big test/'

cat > data1.txt << "EOF"
The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.
EOF

sed 's/dog/cat/' data1.txt


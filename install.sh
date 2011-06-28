INSTALL_WHAT=${1:-"everything"}

if [ -d /tmp/vim ]
then
  rm -rf /tmp/vim
fi

cd /tmp
hg clone https://vim.googlecode.com/hg/ vim
cd vim
hg pull
hg update

cd src
if [ $INSTALL_WHAT -eq "ruby" ]
then
  echo "Installing on ruby support"
  ./configure --enable-rubyinterp --with-features=huge --enable-multibyte
else
  echo "Installing everything"
  echo "Install new libiconv for perl support"
  wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.13.1.tar.gz
  tar xzf libiconv-1.13.1.tar.gz
  cd libiconv-1.13.1
  CFLAGS='-arch i386 -arch x86_64' CCFLAGS='-arch i386 -arch x86_64' CXXFLAGS='-arch i386 -arch x86_64' ./configure
  make
  sudo make install

  cd ..
  ./configure --enable-rubyinterp --with-features=huge --enable-multibyte --enable-pythoninterp --enable-perlinterp
fi

make
sudo make install

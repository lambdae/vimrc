#!/bin/bash


VHOME=$HOME/.local
mkdir -p $VHOME
HNCURSES=$VHOME/ncurses
HVIM=$VHOME/vim
HCONF=$VHOME/dconf
NCURSE_URL=http://dconf.oss-cn-beijing.aliyuncs.com/ncurses-5.8.tar.gz
VIM_URL=http://dconf.oss-cn-beijing.aliyuncs.com/vim-8.0.tar.bz2


function build_ncurse() {
    wget $NCURSE_URL
    tar xvzf ncurses-5.8.tar.gz
    cd ncurses-5.8

    ./configure --prefix=$HNCURSES
    make
    make install
    cd ..
}


function build_vim() {
    wget $VIM_URL
    tar xvjf vim-8.0.tar.bz2
    cd vim80
    export LDFLAGS="-L$HNCURSES/lib"
    make distclean
    ./configure --enable-gui=no --without-x -with-features=huge \
        --prefix=$HVIM --with-tlib=ncurses \
        --enable-pythoninterp
    make
    make install
    cp $HVIM/bin/vim $HVIM/bin/dvim
    cd ..
}


build_ncurse
build_vim

rm -rf $HCONF
cp -rf dconf $VHOME
cd $HCONF
sh install_vundle.sh

echo "set nocompatible" >> vimrc.new
echo "set rtp+=$HCONF/bundle/vundle/" >> vimrc.new
echo "call vundle#rc(\"$HCONF/bundle/vundle\")" >> vimrc.new
cat vimrc >> vimrc.new
mv vimrc.new vimrc

echo "export VIM_DIR=$HVIM" > ~/.limrc
echo "export VIMRUNTIME=\$VIM_DIR/share/vim/vim80" >> ~/.limrc
echo "export EDITOR=dvim" >> ~/.limrc
echo "export PATH=\$VIM_DIR/bin:\$PATH" >> ~/.limrc
echo "alias lim='dvim -u $HCONF/vimrc'" >> ~/.limrc


#!/bin/bash

VIM_DEPENDECIES="libncurses5-dev libgnome2-dev libgnomeui-dev libgtk2.0-dev \
				 libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev \
				 libxpm-dev libxt-dev python-dev python3-dev ruby-dev \
				 lua5.1 liblua5.1-dev libperl-dev git"

OLD_VIM_INSTALLATIONS="vim vim-runtime gvim vim-tiny vim-common vim-gui-common vim-nox"

function Vim_Cleanup() {
	apt-get remove $OLD_VIM_INSTALLATIONS
	return 0
}

function Vim_Install_Dependencies() {
	apt-get install $VIM_DEPENDENCIES
	return 0
}

function Vim_Build() {
	mkdir -p "$1"
	cd "$1"
	git clone https://github.com/vim/vim.git
	cd vim
	make distclean
	./configure --with-features=huge \
				--enable-multibyte \
				--enable-rubyinterp=yes \
				--enable-pythoninterp=yes \
				--with-python-config-dir=`python-config --configdir` \
				--enable-python3interp=yes \
				--with-python3-config-dir=`python3-config --configdir` \
				--enable-perlinterp=yes \
				--enable-luainterp=yes \
				--enable-gui=auto \
				--enable-cscope \
				--prefix=/usr/local
	make VIMRUNTIMEDIR="$2" -j 4
	return 0
}

function Vim_Install() {
	make install
	return 0
}

function Vim_Set_Alternatives() {
	update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
	update-alternatives --set editor /usr/local/bin/vim
	update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
	update-alternatives --set vi /usr/local/bin/vim
	return 0
}

function Vim_Move_Config() {
	rm -rf "$2/.vimrc"
	cp "$1/vim/.vimrc" "$2/.vimrc"
	chown $3:$3 "$2/.vimrc"
}

function Vim_Install_Plugins() {
	rm -rf "$2/.vim/"
	git clone https://github.com/VundleVim/Vundle.vim.git "$1/.vim/bundle/Vundle.vim"
	chown -R $2:$2 "$1"
	vim +PluginInstall +qall
	python3 ~/.vim/bundle/YouCompleteMe/install.py --clang-completer
}

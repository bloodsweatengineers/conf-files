#!/bin/bash

VIM_DEPENDECIES="libncurses5-dev libgnome2-dev libgnomeui-dev libgtk2.0-dev \
				 libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev \
				 libxpm-dev libxt-dev python-dev python3-dev ruby-dev \
				 lua5.1 liblua5.1-dev libperl-dev git"

OLD_VIM_INSTALLATIONS="vim vim-runtime gvim vim-tiny vim-common vim-gui-common vim-nox"

function Vim_Install_Dependencies() {
	apt-get install $VIM_DEPENDECIES
	return 0
}

function Vim_Remove_Old_Vim() {
	apt-get remove $OLD_VIM_INSTALLATIONS
	return 0
}

function Error() {
	echo -e "\e[31m$1\e[39m"
}

function Info() {
	echo -e "\e[33m$1\e[39m"
}

function Success() {
	echo -e "\e[32m$1\e[39M"
}

function Vim_Build() {

	Info "Installing dependencies for vim"
	if vim_install_dependencies; then
		Success "Successfully installed dependencies"
	else
		Error "Failed to install dependencies"
		return 1
	fi

	if Vim_Remove_Old_Vim; then
		Success "Successfully removed old vim installation"
	else
		Error "Failed to remove old vim installation"
		return 1
	fi

	cd $1
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
	make VIMRUNTIMEDIR=$2 -j 4
	make install

	update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
	update-alternatives --set editor /usr/local/bin/vim
	update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
	update-alternatives --set vi /usr/local/bin/vim

	Success "Installed vim"
}

function Vim_Install_Plugins() {
	rm -rf /home/$SUDO_USER/.vim/
	rm -rf /home/$SUDO_USER/.vimrc

	cp vim/.vimrc /home/$SUDO_USER/.vimrc
	sudo -u $SUDO_USER git clone https://github.com/VundleVim/Vundle.vim.git /home/$SUDO_USER/.vim/bundle/Vundle.vim
	sudo -u $SUDO_USER vim +PluginInstall +qall
	python3 ~/.vim/bundle/YouCompleteMe/install.py --clang-completer
}


Info "Trying to install vim and plugins..."

VIM_DIR=`which vim`

if [[ -z "$VIM_DIR" ]]; then
	Error "Vim not found, starting installation..."
	Vim_Install ~ /usr/local/share/vim/vim81
	Vim_Install_Plugins
elif [[ -n "$VIM_DIR" ]]; then
	Success "Vim found, installing plugins..."
	Vim_Install_Plugins
fi

#!/bin/bash

VERSION="Configuration installation ver-0.0.0"
USER=`id -u -n`
CURRENT_DIR=`pwd`

VERBOSE=0
BUILD_DIR="build/"
CONF_ONLY=0
ROOT=0
USER_HOME=

function Success() {
	echo -e "\e[32mSuccess:\t$1\e[39m"
}

function Info() {
	echo -e "\e[33mInfo:\t$1\e[39m"
}

function Error() {
	echo -e "\e[31mError:\t$1\e[39m"
}

function Fatal() {
	Error "$1"
	Error "Exiting"
}

function Echo_If_Verbose() {
	if [[ $VERBOSE -eq 1 ]]; then
		case "$1" in
			success )
				Success "$2"
				;;
			info )
				Info "$2"
				;;
			error )
				Info "$2"
				;;
			fatal )
				Info "$2"
				;;
		esac
	fi
}

source ./vim/install_vim.sh
#source ./vim/install_awesome.sh

function Vim_Installation() {
	Info "Starting vim installation"
	Echo_If_Verbose info "Cleaning up old vim installations"
	if Vim_Cleanup; then
		Echo_If_Verbose success "Cleaned up old vim installations"
	else
		Fatal "Failed to clean up old vim installations"
		exit
	fi

	Echo_If_Verbose info "Installing dependencies of vim"
	if Vim_Install_Dependencies; then
		Echo_If_Verbose success "Installed dependencies"
	else
		Fatal "Failed to install dependencies of vim"
		exit
	fi

	Echo_If_Verbose info "Building vim"
	if Vim_Build $BUILD_DIR $VIM_SHARE_DIR; then
		Echo_If_Verbose success "Build vim"
	else
		Fatal "Failed to Build vim"
		exit
	fi

	Echo_If_Verbose info "Installing vim"
	if ! Vim_Install; then
		Fatal "Failed to install vim"
		exit
	fi

	Echo_If_Verbose info "Setting alternatives"
	if Vim_Set_Alternatives; then
		Echo_If_Verbose success "Set alternatives"
	else
		Error "Failed to set alternatives"
	fi

	Success "Installed vim"
}

function Vim_Plugin_Installation() {
	Info "Moving vim config"
	Vim_Move_Config $CURRENT_DIR $USER_HOME $USER
	Echo_If_Verbose success "Moved vim config"
	Info "Installing Plugins"
	Vim_Install_Plugins $USER_HOME $USER
	Success "Installed Plugins"
}

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do 
	case $1 in
		-V | --version )
			echo $VERSION
			exit
			;;
		-v | --verbose )
			VERBOSE=1 
			;;
		--build-dir )
			shift;
			BUILD_DIR=$1
			;;
		--conf-only )
			CONF_ONLY=1
			;;
		--root )
			ROOT=1
			;;
	esac; shift;
done

if [[ $CONF_ONLY -eq 0 ]]; then
	if [[ "$USER" == "root" && -z $SUDO_USER && $ROOT -eq 0 ]]; then
		Fatal "This script needs to be run with sudo or with --root."
		exit;
	elif [[ "$USER" != "root" ]]; then
		Fatal "This script needs some elevated privileges."
		exit;
	fi
fi

if [[ $ROOT -eq 1 ]]; then
	USER_HOME=~
else
	USER_HOME="/home/$SUDO_USER"
	USER=$SUDO_USER
fi

if [[ $VERBOSE -eq 1 ]]; then
	Info "Build directory\t: $BUILD_DIR"
	Info "Home directory\t: $USER_HOME"
	if [[ $CONF_ONLY -eq 1 ]]; then
		Info "Running configuration only"
	fi
	if [[ $ROOT -eq 1 ]]; then
		Info "Forcibly running root configuration"
	fi
fi

if [[ $CONF_ONLY -eq 0 ]]; then
	Vim_Installation
	Vim_Plugin_Installation
else
	Vim_Plugin_Installation
fi

Info "Cleaning up"
rm -rf "$CURRENT_DIR/$BUILD_DIR"
Success "Done. Exiting"

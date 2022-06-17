#!/bin/bash

#Brief : This script is used to install habitat, configure habitat and configure Refresh environment

set -eou pipefail

main() {
	local INSTALL=""
	local SETUP_REFRESH=""

	for a in "$@";
	do
		case $a in
			-i=*|--install=*)
			INSTALL="${a#*=}"
			shift # past argument=value
			;;
			-r=*|--refreshsetup=*)
			SETUP_REFRESH="${a#*=}"
			shift # past argument=value
			;;
			-*|--*)
			echo "ERR: Unknown option $a"
			exit 1
			;;
			*)
			;;
		esac
	done

	if [[ $INSTALL == "linux" ]];
	then
		# install hab for linux
		installHabitat "x86_64-linux"
		printf "INFO: >*-()> habitat for linux is installed \n"
		exit 0
	elif [[ $INSTALL == "linux2" ]];
	then
		# install hab for linux2
		installHabitat "x86_64-linux-kernel2"
		printf "INFO: >*-()> habitat for linux2 is installed \n"
		exit 0
	fi

	if [[ $SETUP_REFRESH == "linux" || $SETUP_REFRESH == "linux2" ]];
	then
		# configure package refresh
		setupPackageRefresh $SETUP_REFRESH
		printf "INFO: >*-()> habitat package refresh setup is finished :) \n"
		exit 0
	fi
}

installHabitat() {
	# install habitat program
	curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | sudo bash -s -- -t $1

	# set habitat license
	hab license accept

	# set/configure habitat conf file
	mkdir -p /home/ubuntu/.hab/etc
	curl https://raw.githubusercontent.com/timin/myutil/main/pkg_refresh/conf/cli.toml --output /home/ubuntu/.hab/etc/cli.toml
	
	# download public key from on-premise BLDR
	hab origin key download core

	# download private key from on-premise BLDR
	hab origin key download core --secret
}

setupPackageRefresh() {
	local tt=$1

	# update ubuntu packages
	#sudo apt -qq update
	#sudo apt -qq upgrade -y
	
	# create directory
	mkdir -p /home/ubuntu/Refresh/conf /home/ubuntu/Refresh/script
	
	# set ssl certificate
	curl https://raw.githubusercontent.com/timin/myutil/main/pkg_refresh/conf/ssl_certificate.pem --output /home/ubuntu/Refresh/conf/ssl_certificate.pem
	
	# hab env variables
	curl https://raw.githubusercontent.com/timin/myrepo/main/pkg_refresh/conf/refresh.rc --output /home/ubuntu/Refresh/conf/refresh.rc
	
	# set env in bashrc
	echo "source /home/ubuntu/Refresh/conf/refresh.rc" >> /home/ubuntu/.bashrc
	source /home/ubuntu/Refresh/conf/refresh.rc
	
	if [[ $tt == "linux" ]];
	then
		curl https://raw.githubusercontent.com/timin/myrepo/main/pkg_refresh/conf/linux/packageForLinux_essential.txt --output /home/ubuntu/Refresh/conf/packageForLinux_essential.txt
		curl https://raw.githubusercontent.com/timin/myrepo/main/pkg_refresh/conf/linux/packageForLinux.txt --output /home/ubuntu/Refresh/conf/packageForLinux.txt
	elif [[ $tt == "linux2" ]];
	then
		curl https://raw.githubusercontent.com/timin/myrepo/main/pkg_refresh/conf/linux2/packageForLinux2_essential.txt --output /home/ubuntu/Refresh/conf/packageForLinux2_essential.txt
		curl https://raw.githubusercontent.com/timin/myrepo/main/pkg_refresh/conf/linux2/packageForLinux2.txt --output /home/ubuntu/Refresh/conf/packageForLinux2.txt
	fi
	
	# copy script files
	#curl

	# clone package repo
	git clone --branch $REFRESH_BRANCH https://github.com/habitat-sh/core-plans.git /home/ubuntu/Refresh/repo
}

main "$@" || exit 99

#!/bin/bash

set -eou pipefail

main() {
	for a in "$@";
	do
		case $a in
			-i=*|--install=*)
			INSTALL="${a#*=}"
			shift # past argument=value
			;;
			-s=*|--setup=*)
			SETUP="${a#*=}"
			shift # past argument=value
			;;
			-*|--*)
			echo "Unknown option $a"
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
	elif [[ $INSTALL == "linux2" ]];
	then
		# install hab for linux2
		installHabitat "x86_64-linux-kernel2"
	fi

	if [[ $SETUP == "habitat" ]];
	then
		# configure habitat
		setupHabitat
	elif [[ $SETUP == "refresh" ]];
	then
		# configure package refresh
		setupPackageRefresh
	fi
}

installHabitat() {
	# update ubuntu packages
	sudo apt update
	sudo apt upgrade -y

	# install habitat program
	curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | sudo bash -s -- -t $1

	# set habitat license
	hab license accept
}

setupHabitat() {
	# configure habitat
	curl https://raw.githubusercontent.com/timin/myutil/main/pkg_refresh/conf/cli.toml --output /home/ubuntu/.hab/etc/cli.toml
	
	# set ssl certificate
	curl https://raw.githubusercontent.com/timin/myutil/main/pkg_refresh/conf/ssl_certificate.pem --output /home/ubuntu/.hab/cache/ssl/cert.pem
	
	# download public key from on-premise BLDR
	hab origin key download core
	
	# download private key from on-premise BLDR
	hab origin key download core --secret
	
	# create directory for package refresh
	mkdir -p /home/ubuntu/Refresh
	cd /home/ubuntu/Refresh/
	
	# hab studio(or plan builder) ready for use
}

setupPackageRefresh() {
	cd /home/ubuntu/Refresh
	mkdir -p conf script

	# copy conf files
	curl https://raw.githubusercontent.com/timin/myrepo/main/pkg_refresh/conf/refresh.rc --output /home/ubuntu/Refresh/conf/refresh.rc
	curl https://raw.githubusercontent.com/timin/myrepo/main/pkg_refresh/conf/refresh.conf --output /home/ubuntu/Refresh/conf/refresh.conf
	curl https://raw.githubusercontent.com/timin/myrepo/main/pkg_refresh/conf/linux2/packageForLinux2_essential.txt --output /home/ubuntu/Refresh/conf/packageForLinux2_essential.txt
	curl https://raw.githubusercontent.com/timin/myrepo/main/pkg_refresh/conf/linux2/packageForLinux2.txt --output /home/ubuntu/Refresh/conf/packageForLinux2.txt

	# copy script files
	exit 1
}

main "$@" || exit 99

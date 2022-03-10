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
	elif [[$INSTALL == "linux2" ]];
	then
		# install hab for linux2
		installHabitat "x86_64-linux-kernel2"
	fi

	if [[ $SETUP == "" ]];
	then
		# configure habitat
		setupHabitat
	elif [[ $SETUP == "" ]];
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
	curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | sudo bash -s -- -t $type

	# set habitat license
	hab license accept
}

setupHabitat() {
	# configure habitat
	curl https://raw.githubusercontent.com/timin/myutil/main/pkg_refresh/conf/cli.toml --output /home/ubuntu/.hab/etc/cli.toml
	
	# set ssl certificate
	curl https://raw.githubusercontent.com/timin/myutil/main/pkg_refresh/conf/ssl_certificate.pem --output /home/ubuntu/.hab/cache/ssl/cert.pem
	
	# download public key from BLDR
	hab origin key download core
	
	# download private key from BLDR
	hab origin key download core --secret
	
	# create directory for package refresh
	mkdir -p /home/ubuntu/Refresh
	cd /home/ubuntu/Refresh/
	
	# hab studio(or plan builder) ready for use
}

setupPackageRefresh() {
	cd /home/ubuntu/refresh
	mkdir -p conf script

	# copy conf files
	curl https://raw.githubusercontent.com/timin/myutil/main/pkg_refresh/linux2/conf/packageForLinux2_baseplans.txt
	# copy script files
	exit 1
}

main "$@" || exit 99

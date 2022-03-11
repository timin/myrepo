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
		printf "habitat for linux is installed \n"
	elif [[ $INSTALL == "linux2" ]];
	then
		# install hab for linux2
		installHabitat "x86_64-linux-kernel2"
		printf "habitat for linux2 is installed \n"
	else
		# error
		printf "unknown -i parameter value \n"
		exit 99
	fi

	if [[ $SETUP == "y" ]];
		# configure habita
		setupHabitat

		# configure package refresh
		#setupPackageRefresh
		print "habitat package refresh setup is finished :) \n"
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
	mkdir -p /home/ubuntu/Refresh/conf /home/ubuntu/Refresh/script
	
	# configure habitat
	curl https://raw.githubusercontent.com/timin/myutil/main/pkg_refresh/conf/cli.toml --output /home/ubuntu/Refresh/conf/cli.toml
	
	# set ssl certificate
	curl https://raw.githubusercontent.com/timin/myutil/main/pkg_refresh/conf/ssl_certificate.pem --output /home/ubuntu/Refresh/conf/ssl_certificate.pem
	
	# hab env variables
	curl https://raw.githubusercontent.com/timin/myrepo/main/pkg_refresh/conf/refresh.rc --output /home/ubuntu/Refresh/conf/refresh.rc
	
	# download public key from on-premise BLDR
	hab origin key download core
	
	# download private key from on-premise BLDR
	hab origin key download core --secret
	
	# set env in bashrc
	echo "source /home/ubuntu/Refresh/conf/refresh.rc" > /home/ubuntu/.bashrc
}

setupPackageRefresh() {
	# set refresh conf
	# copy conf files
	curl https://raw.githubusercontent.com/timin/myrepo/main/pkg_refresh/conf/refresh.conf --output /home/ubuntu/Refresh/conf/refresh.conf

	curl https://raw.githubusercontent.com/timin/myrepo/main/pkg_refresh/conf/linux2/packageForLinux2_essential.txt --output /home/ubuntu/Refresh/conf/packageForLinux2_essential.txt
	curl https://raw.githubusercontent.com/timin/myrepo/main/pkg_refresh/conf/linux2/packageForLinux2.txt --output /home/ubuntu/Refresh/conf/packageForLinux2.txt

	# copy script files
	# clone package repo
	git clone https://github.com/habitat-sh/core-plans.git /home/ubuntu/Refresh/repo
	git --git-dir /home/ubuntu/Refresh/repo/.git switch $REFRESH_BRANCH
}

main "$@" || exit 99

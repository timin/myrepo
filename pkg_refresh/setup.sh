#!/bin/bash

set -eou pipefail

main() {
	setupHabitat
	setupPackageRefresh
}

setupHabitat() {
	# update ubuntu packages
	sudo apt update
	sudo apt upgrade -y

	# install habitat program
	curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | sudo bash -s -- -t x86_64-linux-kernel2

	# set habitat license
	hab license accept

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
	exit 1
}

main "$@" || exit 99
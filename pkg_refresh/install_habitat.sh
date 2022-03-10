#!/bin/bash

set -eou pipefail

main() {
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
	
	# download public key from BLDR
	hab origin key download core --secret

  exit

	# download orign keys (public and private)
	hab origin key download core
	hab origin key download core --secret

	# clone repo
}

main "$@" || exit 99

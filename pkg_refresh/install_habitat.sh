#!/bin/bash

set -eou pipefail

main() {
	# update ubuntu packages
	sudo apt update
	sudo apt upgrade -y

	# install Habitat program
	curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | sudo bash -s -- -t x86_64-linux-kernel2

	# set hab cli
  exit

	# download orign keys (public and private)
	hab origin key download core
	hab origin key download core --secret

	# clone repo
}

main "$@" || exit 99

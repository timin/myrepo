### How to set up hab-auto-build on new machine
### How to build core-packages on new machine

**Note: Habitat and hab-auto-build tool needs superuser priviliges. Run as sudo**

* Create EC2 machine for x86/aarch64
* Install Habitat using "curl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | sudo bash"
* Setup hab for root user "sudo hab cli setup"

  Note: Follow instructions on screen to setup habitat
* Replace '/usr/bin/hab' softlink with Hab binary '/hab/pkgs/core/hab/1.6.826/20230808223208/bin/hab'
* Delete installation directory '/hab/pkgs/*'
* Delete artifacts directory '/hab/cache/artifacts/*' and '~/.hab/cache/artifacts/*'
* Set up Docker

  Note: Follow steps on page https://docs.docker.com/engine/install/ubuntu/

  Note: Follow post installation steps on page https://docs.docker.com/engine/install/linux-postinstall/
* Set up hab-auto-build tool using 'sudo make setup'

  Note: Install all requites for building core-packages
* Update environment using 'sudo make update'
* Build packages using 'sudo make build-debug PACKAGE="core/hab-sup"' or 'HAB_AUTO_BUILD_DEBUG=hab-auto-build=debug sudo -E $(which hab-auto-build) build core/hab-sup'

  Note: studio created by hab-auto-build tool is named '/hab/studios/hab-auto-build-1'

  Note: Update Rust version in native and bootstrap packages

  Note: update Habitat version

### To enable debugging in hab-auto-build binary
export HAB_AUTO_BUILD_DEBUG=hab_auto_build=debug

export HAB_AUTO_BUILD_DEBUG=hab_auto_build=trace

# How to setup instance for Package Refresh

Below are instruction manual to setup machine for Package Refresh; building packages in particular order to be uploaded to Public Builder to user to comsume.

**A. On Linux**

**B. On Linux2**

1. Setup a Linux2 environment for builing packages, [tutorial](./habitat_setup.md)
2. Install Ruby using command "sudo apt install ruby -y"
3. Install Gems using command "sudo gem install dotenv"
4. Download script for Package Refresh using command "git clone git@github.com:habitat-sh/core-plans-dev.git --branch nimitworks ~/Refresh"
5. Change directory using command "cd ~/Refresh"
6. Copy files using command "cp linux2/* ."
7. Download and setup packages repos using command "ruby script/setupRepo.rb"
8. Build package as per build order using command "ruby script/refresh.rb"

**C. On Windows**

1. Setup a Windows environment for builing packages, [tutorial](./habitat_setup.md)
2. Install Ruby using command "choco install ruby -y"
3. Install Gems using command "gem.cmd install dotenv"
4. Install Git using command "choco install git -y"
5. Download script for Package Refresh using command "git clone git@github.com:habitat-sh/core-plans-dev.git --branch nimitworks ~/Refresh"
6. Change directory using command "cd c:\Users\Administrator\Documents\Refresh"
7. Copy files using command "cp windows\* ."
9. Download and setup packages repos using command "ruby.exe script\setupRepo.rb"
10. Build package as per build order using command "ruby.exe script\refresh.rb"

# How to setup Chef Habitat

Below are instruction manual to install, configure and connect Habitat to Builder in order to build packages on platform (Linux, Linux2, Windows etc)

### A. On Linux

### B. On Linux2

1. Create AWS instance
2. Install Habitat using command "curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | sudo bash -s -- -t x86_64-linux-kernel2"
3. Configure Habitat CLI using command "hab cli setup" and follow instructions on screen

   **Note: Do not generate origin key using setup, can be downloaded from Builder**

4. Copy SSL certificate of Builder to machine
5. Configure SSL certificate of Builder in bashrc, adding "export SSL_CERT_FILE=<path_tossl_certificate_file>"
6. Download public origin key using command "hab origin key download core"
7. Download private key using command "hab origin key download core --secret"
8. Create directory using command "mkdir -p /home/ubuntu/Refresh/download /home/ubuntu/Refresh/conf /home/ubuntu/Refresh/script"
9. Change current directory using command "cd /home/ubuntu/Refresh"
10. Run Studio to build package using command "hab studio enter"

      **Note: hab studio will fail to start because essential packages are not present in Builder**

11. Copy essential package list (filename:packageForLinux2_essential.txt) for linux2 to directory "/home/ubuntu/Refresh/conf"
12. Download packages from Public Builder using command "hab pkg download --download-directory download --channel=stable --target x86_64-linux-kernel2 --file ./conf/packageForLinux2_essential.txt -u https://bldr.habitat.sh -z _Qk9YLTEKYmxkci0yMDE3MDkyNzAyMzcxNApibGRyLTIwMTcwOTI3MDIzNzE0Cm0wanhRRjFwaUxiekdmaUt3L1RYdG1UVFpNOFh2Q3ExClkxSkkrWEJ3Zml2cjB2eitXNVdVNmd0VVVRemg2alJoRXlLd0NOV1RuaXBuNTdXeQ=="
13. Upload packages to on-premise Builder using command "hab pkg upload --cache-key-path download/keys/ -c stable download/artifacts/core*"
14. Open/Enter Hab Studio using command "hab studio enter"
      Note: Hab Studio will download packages required to work with Studio

### C. On Windows

1. Create AWS instance

   **Note: Check containers feature is enabled on server**

2. Install Habitat using below commands
   "Set-ExecutionPolicy Bypass -Scope Process -Force"
   "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.ps1'))"
3. Configure Habitat CLI using command "hab.exe cli setup" and follow instructions on screen

   **Note: Do not generate origin key using CLI setup, can be downloaded from Builder**
   
4. Copy SSL certificate of Builder to path "C:\hab\cache\ssl"
5. Download public origin key using command "hab origin key download core"
6. Download private key using command "hab origin key download core --secret"
7. Create directory using command "mkdir c:\Users\Administrator\Documents\Refresh\download; mkdir c:\Users\Administrator\Documents\Refresh\conf; mkdir c:\Users\Administrator\Documents\Refresh\script"
8. Change current directory using command "cd c:\Users\Administrator\Documents\Refresh"
9. Run Studio to build package using command "hab.exe studio enter"

      **Note: Hab studio will fail to start because essential packages are not present in Builder**

10. Copy essential package list (filename:packageForWindows_essential.txt) for windows to directory "c:\Users\Administrator\Documents\Refresh\conf"
11. Download packages from Public Builder using command "hab.exe pkg download --download-directory download --channel=stable --target x86_64-windows --file .\conf\packageForWindows_essential.txt -u https://bldr.habitat.sh -z _Qk9YLTEKYmxkci0yMDE3MDkyNzAyMzcxNApibGRyLTIwMTcwOTI3MDIzNzE0Cm0wanhRRjFwaUxiekdmaUt3L1RYdG1UVFpNOFh2Q3ExClkxSkkrWEJ3Zml2cjB2eitXNVdVNmd0VVVRemg2alJoRXlLd0NOV1RuaXBuNTdXeQ=="
12. Upload packages to on-premise Builder using command "hab.exe pkg upload --cache-key-path .\download\keys\ -c stable .\download\artifacts\core-hab-studio-1.6.351-20210706203941-x86_64-windows.hart"
13. Install Chocolatey https://chocolatey.org/install
14. Install Docker CLI using command "choco install docker-cli -y"
15. Install Docker Desktop using command "choco install docker-desktop -y"
16. Open/Enter Hab Studio using command "hab.exe studio enter -D"
      Note: Hab Studio will download packages required to work with Studio

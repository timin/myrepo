# How to setup Habitat Builder
### A. Using Chef Automate
Habitat Builder can be installed using Chef Automate. It is also used for authentication while using Builder. To install Automate follow below steps.
 
1. Create AWS instance with minimum (8 CPU, 32GB of RAM, 100 GB of disk)
2. Update Linux package index using command "sudo apt update"
3. update Linux package using command "sudo apt upgrade"
4. Create a directory using command "mkdir /home/ubuntu/Automate"
5. Switch to newly created directory "cd /home/ubuntu/Automate"
6. Generate a SSL certificate using command "openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ssl_key.pem -out ssl_certificate.pem -subj "/C=US/ST=Oregon/L=Portland/O=Company/OU=Dept/CN=<public_dns_of_machine>""
7. Update kernel parameters for better performance:

    "sudo sysctl -w vm.max_map_count=655300"

    "sudo sysctl -w vm.dirty_expire_centisecs=30000"

    "sudo sysctl -p"
7. Install Chef Automate using command "curl https://packages.chef.io/files/current/latest/chef-automate-cli/chef-automate_linux_amd64.zip | gunzip - > chef-automate && chmod +x chef-automate"
8. Initialize Automate configuration file using command "sudo ./chef-automate init-config --fqdn <public_dns_of_machine> --certificate /home/ubuntu/Automate/ssl_certificate.pem --private-key /home/ubuntu/Automate/ssl_key.pem"
9. File named "config.toml" will be generated in current directory with default configuration, if required you can add/edit/update (DEFAULT IS GOOD ENOUGH)
10. Deploy Automate using command "sudo ./chef-automate deploy --accept-terms-and-mlsa --product automate,builder config.toml"
11. Copy Automate license file to path "curl https://raw.githubusercontent.com/timin/myutil/main/pkg_refresh/conf/automate_license --output automate_license"
12. Apply Automate license using command "sudo ./chef-automate license apply automate_license"
13. Check status of Automate services using command "sudo ./chef-automate status"
14. Get Automate access and login details using command "sudo cat automate-credentials.toml"
15. Chef Automate is ready to use.

**To install Builder**

<ins>**Note: These section is applicable if in steps 10 only automate is installed otherwise can be skipped**</ins>

15. Create a patch.toml file to add builder to the list of products to deploy.
    [deployment.v1.svc]
    products=["automate", "builder"]
16. Install Builder using command "sudo ./chef-automate config ./patch.toml"
17. Get access of Builder GUI at "https://<public_dns_of_machine>/bldr"
18. Builder API URL is "https://<public_dns_of_machine>/bldr/v1"
19. [Configure Builder after first login](https://github.com/habitat-sh/core-plans-dev/blob/nimitworks/guides/builder_setup.md#how-to-configure-habitat-builder)


### B. Using Installer

1. Create AWS instance
2. Install Git
3. Configure Git
4. Clone Builder Repo using command "git clone git@github.com:habitat-sh/on-prem-builder.git builder/" 
5. Copy Builder configuration file using command "cp bldr.env.sample bldr.env"
6. Update configuration parameters in environment file as per requirement
    Note: To run on AWS, update parameter HAB_BLDR_URL to http://bldr.habitat.sh/
7. Update parameter MINIO_ENDPOINT to http://<public_ip_of_machine>:9000
8. Update parameter APP_URL to http://<public_ip_of_machine>/
9. Update parameter OAUTH_REDIRECT_URL to http://<public_ip_of_machine>/
10. Update parameter OAUTH_CLIENT_ID to "Github Client Id App Id"
11. Update parameter OAUTH_CLIENT_SECRET. to Github Client sceret"
12. Install Builder using command “./install.sh”
13. Start Builder services using command "sudo systemctl restart hab-sup"
14. To check Builder services are up, using command "sudo hab svc status"
15. Login to Builder UI using URL defined at APP_URL with github auth
16. [Configure Builder after first login](https://github.com/habitat-sh/core-plans-dev/blob/nimitworks/guides/builder_setup.md#how-to-configure-habitat-builder)


# How to configure Habitat Builder

1. Login to Builder UI with Automate or Github
2. Go to "Profile" page and create personal access token (Auth Token)
3. Set environment variable HAB_AUTH_TOKEN and HAB_BLDR_URL in /home/ubuntu/.bashrc to on-premise builder
5. Create origin named "core"

# Seed packages to on-premise Builder

Habitat packages are often dependent on others habitat packages along with Habitat services hence packages are essential to build and run Hab applications. Copying & pasting packages from Public Builder to on-premise Builder is called seeding packages.

1. Download packages from stable channel of Public Builder using command "hab pkg download --download-directory pkg_download_linux2 --channel=stable --target x86_64-linux-kernel2 --file packageSeedForLinux2.txt -u https://bldr.habitat.sh -z _Qk9YLTEKYmxkci0yMDE3MDkyNzAyMzcxNApibGRyLTIwMTcwOTI3MDIzNzE0Cm0wanhRRjFwaUxiekdmaUt3L1RYdG1UVFpNOFh2Q3ExClkxSkkrWEJ3Zml2cjB2eitXNVdVNmd0VVVRemg2alJoRXlLd0NOV1RuaXBuNTdXeQ=="
2. Upload packages to unstable channel of on-premise Builder using command "hab pkg bulkupload --url http://<public_dns_of_machine>/ --auth <hab_auth_token> --channel unstable pkg_download_linux2/"
3. Promote packages from unstable to stable channel of on-premise Builder using command "hab pkg promote –url http://<public_dns_of_machine> –channel stable pkg_download_linux2/"

# DVWA-installer-script
Automated way to install dvwa

# Automated DVWA Installation on Arch Linux

The script installs the necessary components, configures them, and sets up DVWA for you.

## Requirements

Before running the script, ensure that you have the following:

- Arch Linux installed and updated
- Root or sudo privileges

## Components Installed

The script will install and configure the following components:
- Apache (Web server)
- MariaDB (Database server)
- PHP (Server-side scripting language)
- DVWA (Damn Vulnerable Web Application)

## The password will be set to

```
password

```
# So change it incase you want a different password

Change these lines in the code

```
sudo mysql -u root -proot_password -e "GRANT ALL PRIVILEGES ON dvwa.* TO 'dvwauser'@'localhost' IDENTIFIED BY 'password';"

```
In the DVWA configuration file (config.inc.php):

```
sudo sed -i "s/''/'password'/g" config.inc.php

```

## Installation Steps

Follow these steps to install DVWA on Arch Linux using the provided script.

## Clone the Repository

Clone this repository to your local machine:

```bash
git clone https://github.com/JoeSaf/DVWA-installer-script.git
cd DVWA-installer-script

```


## Make the script executable

```
chmod +x dvwa_arch_installer.sh


```
## Run the installation script

```
./dvwa_arch_installer.sh

```

## To access after installtion, copy the link and paste it in your browser

```
http://localhost/DVWA

```

## Log In to DVWA
Username: admin
Password: password

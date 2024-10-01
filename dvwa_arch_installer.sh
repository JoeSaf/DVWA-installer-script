#!/bin/bash

echo "Updating system and installing required packages..."
sudo pacman -Syu --noconfirm
sudo pacman -S apache mariadb php php-apache git --noconfirm

echo "Enabling and starting Apache and MariaDB..."
sudo systemctl enable httpd
sudo systemctl start httpd

sudo systemctl enable mariadb
sudo systemctl start mariadb

# MariaDB installation
echo "Securing MariaDB installation..."
sudo mysql_secure_installation <<EOF

y
root_password
root_password
y
y
y
y
EOF

# DVWA database and user
echo "Creating DVWA database and user..."
sudo mysql -u root -proot_password -e "CREATE DATABASE dvwa;"
sudo mysql -u root -proot_password -e "GRANT ALL PRIVILEGES ON dvwa.* TO 'dvwauser'@'localhost' IDENTIFIED BY 'password';"
sudo mysql -u root -proot_password -e "FLUSH PRIVILEGES;"


echo "Configuring PHP..."
sudo sed -i 's/;extension=mysqli/extension=mysqli/g' /etc/php/php.ini
sudo sed -i 's/;extension=gd/extension=gd/g' /etc/php/php.ini
sudo sed -i 's/allow_url_fopen = Off/allow_url_fopen = On/g' /etc/php/php.ini
sudo sed -i 's/allow_url_include = Off/allow_url_include = On/g' /etc/php/php.ini
sudo sed -i 's/display_errors = Off/display_errors = On/g' /etc/php/php.ini
sudo sed -i 's/max_execution_time = 30/max_execution_time = 200/g' /etc/php/php.ini
sudo sed -i 's/file_uploads = Off/file_uploads = On/g' /etc/php/php.ini


echo "Downloading and configuring DVWA..."
cd /srv/http
sudo git clone https://github.com/digininja/DVWA.git
sudo chown -R http:http DVWA


echo "Configuring DVWA database connection..."
cd DVWA/config
sudo cp config.inc.php.dist config.inc.php
sudo sed -i "s/'root'/'dvwauser'/g" config.inc.php
sudo sed -i "s/''/'password'/g" config.inc.php
sudo sed -i "s/'dvwa'/'dvwa'/g" config.inc.php


echo "Configuring Apache..."
sudo sed -i 's#DocumentRoot "/srv/http"#DocumentRoot "/srv/http/DVWA"#g' /etc/httpd/conf/httpd.conf
sudo echo -e "\nLoadModule php_module modules/libphp.so\nAddHandler php-script .php\nInclude conf/extra/php_module.conf" >> /etc/httpd/conf/httpd.conf


echo "Restarting Apache..."
sudo systemctl restart httpd

echo "Setting correct file permissions..."
sudo chmod -R 777 /srv/http/DVWA/hackable/uploads
sudo chmod -R 777 /srv/http/DVWA/config


echo "DVWA installation is complete. Access it at: http://localhost/DVWA"

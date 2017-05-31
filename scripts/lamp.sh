#!/bin/bash
echo "Updating System..."
sudo yum update -y > /dev/null 2>&1
echo "...Done!"
echo " "


echo "Installing Apache...(httpd httpd-tools)"
sudo yum install -y httpd httpd-tools > /dev/null 2>&1
echo "...Done!"
echo " "

echo "Installing PHP...(php php-bcmath php-cli php-mbstring php-mysql php-soap php-xml php-xmlrpm)" 
sudo yum install -y php php-bcmath php-cli php-mbstring php-mysql php-soap php-xml php-xmlrpm > /dev/null 2>&1
echo "...Done!"
echo " "

echo "Installing GIT...(git)" 
sudo yum install -y git > /dev/null 2>&1
echo "...Done!"
echo " "

echo "Installing Expect...(expect)" 
sudo yum install -y expect > /dev/null 2>&1
echo "...Done!"
echo " "

echo "Installing MariaDB...(mariadb-server mariadb)"
sudo yum install -y mariadb-server mariadb > /dev/null 2>&1
echo "...Done!"
echo " "

echo "Setting up Apache..."
sudo cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bak
sudo sed -i 's_#ServerName www.example.com:80_ServerName www.abox.dev:80_' /etc/httpd/conf/httpd.conf
sudo sed -i 's_User apache_User vagrant_' /etc/httpd/conf/httpd.conf
sudo sed -i 's_Group apache_Group vagrant_' /etc/httpd/conf/httpd.conf

sudo systemctl enable httpd.service > /dev/null 2>&1
sudo systemctl restart httpd.service > /dev/null 2>&1
echo "...Done!"
echo " "

echo "Setting up MariaDB ... "
sudo systemctl enable mariadb.service > /dev/null 2>&1
sudo systemctl restart mariadb.service > /dev/null 2>&1
mysql -e "UPDATE mysql.user SET Password=PASSWORD('vagrant') WHERE User='root';"
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
mysql -e "DROP DATABASE IF EXISTS test;"
mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
mysql -e "FLUSH PRIVILEGES;"
echo "...Done!"
echo " "

echo "Your aBox LAMP environment is now setup! "
echo " "
echo "MySQL Username: root"
echo "MySQL Password: vagrant"
echo " "
echo "You can copy and paste the following to your hosts file: "
echo " " 
echo "192.168.33.10	abox.dev    www.abox.dev"
echo " "
echo "The 192.168.33.10 is the IP Address in your Vagrantfile."
echo "If you have opted to choose a different IP Address, please adjust accordingly."
echo "Enjoy!"

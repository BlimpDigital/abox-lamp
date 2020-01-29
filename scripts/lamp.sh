#!/bin/bash
echo "Updating System..."
sudo dnf update -y > /dev/null 2>&1
echo "...Done!"
echo " "


echo "Installing Apache...(httpd httpd-tools)"
sudo dnf install -y httpd httpd-tools > /dev/null 2>&1
echo "...Done!"
echo " "

echo "Installing PHP...(php php-bcmath php-cli php-mbstring php-mysql php-soap php-xml php-xmlrpm)" 
sudo dnf install -y php php-fpm php-bcmath php-cli php-mbstring php-mysqlnd php-soap php-xml php-xmlrpc php-json > /dev/null 2>&1
echo "...Done!"
echo " "

echo "Installing GIT...(git)" 
sudo dnf install -y git > /dev/null 2>&1
echo "...Done!"
echo " "

echo "Installing Expect...(expect)" 
sudo dnf install -y expect > /dev/null 2>&1
echo "...Done!"
echo " "

echo "Installing MariaDB...(mariadb-server mariadb)"
sudo dnf install -y mariadb-server mariadb > /dev/null 2>&1
echo "...Done!"
echo " "

echo "Setting up Apache..."
sudo cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bak 
sudo sed -i 's_/var/www/html_/var/www/_' /etc/httpd/conf/httpd.conf
sudo sed -i 's_#ServerName www.example.com:80_ServerName www.abox.local:80_' /etc/httpd/conf/httpd.conf
sudo sed -i 's_User apache_User vagrant_' /etc/httpd/conf/httpd.conf
sudo sed -i 's_Group apache_Group vagrant_' /etc/httpd/conf/httpd.conf
sudo sh -c 'echo "IncludeOptional sites-enabled/*.conf" >> /etc/httpd/conf/httpd.conf'
sudo mkdir /etc/httpd/sites-available/
sudo mkdir /etc/httpd/sites-enabled/
sudo rm -fr /var/www/html

sudo sed -i 's_ScriptAlias /cgi-bin/_#ScriptAlias /cgi-bin/_' /etc/httpd/conf/httpd.conf
sudo sed -i "s/AllowOverride None/AllowOverride All/g" /etc/httpd/conf/httpd.conf
sudo sed -i "s/EnableSendfile on/EnableSendfile Off/g" /etc/httpd/conf/httpd.conf

echo "--> Configuring aBox.local Virtualhost"
sudo mkdir /var/www/abox.local
sudo mkdir /var/www/abox.local/html
sudo touch /var/www/abox.local/html/index.html
sudo sh -c 'echo "This is abox.local" >> /var/www/abox.local/html/index.html'
sudo touch /etc/httpd/sites-available/abox.local.conf
sudo sh -c 'echo "<VirtualHost *:80>
        ServerName      www.abox.local
        ServerAlias     abox.local
        DocumentRoot    /var/www/abox.local/html
</VirtualHost>" >> /etc/httpd/sites-available/abox.local.conf'
sudo ln -s /etc/httpd/sites-available/abox.local.conf /etc/httpd/sites-enabled/abox.local.conf 
echo ".. Done!"

echo "--> Configuring example1.local Virtualhost"
sudo mkdir /var/www/example1.local
sudo mkdir /var/www/example1.local/html
sudo touch /var/www/example1.local/html/index.html
sudo sh -c 'echo "This is example1.local" >> /var/www/example1.local/html/index.html'
sudo touch /etc/httpd/sites-available/example1.local.conf
sudo sh -c 'echo "<VirtualHost *:80>
        ServerName      www.example1.local
        ServerAlias     example1.local
        DocumentRoot    /var/www/example1.local/html
</VirtualHost>" >> /etc/httpd/sites-available/example1.local.conf'
sudo ln -s /etc/httpd/sites-available/example1.local.conf /etc/httpd/sites-enabled/example1.local.conf 
echo "--> .. Done!"

echo "--> Configuring example2.local Virtualhost"
sudo mkdir /var/www/example2.local
sudo mkdir /var/www/example2.local/html
sudo touch /var/www/example2.local/html/index.html
sudo sh -c 'echo "This is example2.local" >> /var/www/example2.local/html/index.html'
sudo touch /etc/httpd/sites-available/example2.local.conf
sudo sh -c 'echo "<VirtualHost *:80>
        ServerName      www.example2.local
        ServerAlias     example2.local
        DocumentRoot    /var/www/example2.local/html
</VirtualHost>" >> /etc/httpd/sites-available/example2.local.conf'
sudo ln -s /etc/httpd/sites-available/example2.local.conf /etc/httpd/sites-enabled/example2.local.conf 
echo "--> .. Done!"

sudo systemctl enable httpd.service > /dev/null 2>&1
sudo systemctl restart httpd.service > /dev/null 2>&1

sudo systemctl enable php-fpm > /dev/null 2>&1
sudo systemctl restart php-fpm > /dev/null 2>&1
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
echo "192.168.33.10	abox.local	www.abox.local"
echo "192.168.33.10	example1.local	www.example1.local"
echo "192.168.33.10	example2.local	www.example2.local"
echo " "
echo "The 192.168.33.10 is the IP Address in your Vagrantfile."
echo "If you have opted to choose a different IP Address, please adjust accordingly."
echo "Enjoy!"
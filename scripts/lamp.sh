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
sudo systemctl enable httpd.service > /dev/null 2>&1
sudo cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bak 
sudo sed -i 's_/var/www/html_/var/www/_' /etc/httpd/conf/httpd.conf
sudo sed -i 's_#ServerName www.example.com:80_ServerName www.abox.dev:80_' /etc/httpd/conf/httpd.conf
sudo sh -c 'echo "IncludeOptional sites-enabled/*.conf" >> /etc/httpd/conf/httpd.conf'
sudo mkdir /etc/httpd/sites-available/
sudo mkdir /etc/httpd/sites-enabled/
sudo rm -fr /var/www/html

sudo sed -i 's_ScriptAlias /cgi-bin/_#ScriptAlias /cgi-bin/_' /etc/httpd/conf/httpd.conf
sudo sed -i "s/AllowOverride None/AllowOverride All/g" /etc/httpd/conf/httpd.conf


echo "--> Configuring aBox.dev Virtualhost"
sudo mkdir /var/www/abox.dev
sudo mkdir /var/www/abox.dev/html
sudo touch /var/www/abox.dev/html/index.html
sudo sh -c 'echo "This is abox.dev" >> /var/www/abox.dev/html/index.html'
sudo touch /etc/httpd/sites-available/abox.dev.conf
sudo sh -c 'echo "<VirtualHost *:80>
        ServerName      www.abox.dev
        ServerAlias     abox.dev
        DocumentRoot    /var/www/abox.dev/html
        ErrorLog        /var/www/abox.dev/error.log
        CustomLog       /var/www/abox.dev/requests.log  combined
</VirtualHost>" >> /etc/httpd/sites-available/abox.dev.conf'
sudo ln -s /etc/httpd/sites-available/abox.dev.conf /etc/httpd/sites-enabled/abox.dev.conf 
echo ".. Done!"

echo "--> Configuring example1.dev Virtualhost"
sudo mkdir /var/www/example1.dev
sudo mkdir /var/www/example1.dev/html
sudo touch /var/www/example1.dev/html/index.html
sudo sh -c 'echo "This is example1.dev" >> /var/www/example1.dev/html/index.html'
sudo touch /etc/httpd/sites-available/example1.dev.conf
sudo sh -c 'echo "<VirtualHost *:80>
        ServerName      www.example1.dev
        ServerAlias     example1.dev
        DocumentRoot    /var/www/example1.dev/html
        ErrorLog        /var/www/example1.dev/error.log
        CustomLog       /var/www/example1.dev/requests.log  combined
</VirtualHost>" >> /etc/httpd/sites-available/example1.dev.conf'
sudo ln -s /etc/httpd/sites-available/example1.dev.conf /etc/httpd/sites-enabled/example1.dev.conf 
echo "--> .. Done!"

echo "--> Configuring example2.dev Virtualhost"
sudo mkdir /var/www/example2.dev
sudo mkdir /var/www/example2.dev/html
sudo touch /var/www/example2.dev/html/index.html
sudo sh -c 'echo "This is example2.dev" >> /var/www/example2.dev/html/index.html'
sudo touch /etc/httpd/sites-available/example2.dev.conf
sudo sh -c 'echo "<VirtualHost *:80>
        ServerName      www.example2.dev
        ServerAlias     example2.dev
        DocumentRoot    /var/www/example2.dev/html
        ErrorLog        /var/www/example2.dev/error.log
        CustomLog       /var/www/example2.dev/requests.log  combined
</VirtualHost>" >> /etc/httpd/sites-available/example2.dev.conf'
sudo ln -s /etc/httpd/sites-available/example2.dev.conf /etc/httpd/sites-enabled/example2.dev.conf 
echo "--> .. Done!"

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
echo "192.168.33.10	abox.dev		www.abox.dev"
echo "192.168.33.10	example1.dev	www.example1.dev"
echo "192.168.33.10	example2.dev	www.example2.dev"
echo " "
echo "The 192.168.33.10 is the IP Address in your Vagrantfile."
echo "If you have opted to choose a different IP Address, please adjust accordingly."
echo "Enjoy!"

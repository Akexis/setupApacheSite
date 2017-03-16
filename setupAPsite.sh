#!/bin/bash

# Section 1 - Create new repository/site folder

echo ''
echo 'Creating a site:'
echo '--------------------------'
echo ''
echo 'What is the name of the repository?'
read repo

echo ''
echo 'Do you need to create the folder?[y/n]'
read folderYesNo
if [ "$folderYesNo" = "y" ]; then
	mkdir /Users/aabbott/Sites/$repo
	chown aabbott $repo
elif [ "$folderYesNo" = "n" ]; then
	echo 'No folder, moving on.'
else
	echo "Sorry, don't understand, you'll have to create it later."
fi

# Section 2 - Create virtual host entry

echo ''
echo 'Setting up VirtualHost in /etc/apache2/extra/httpd-vhosts.conf'

cat << EOF >> /etc/apache2/extra/httpd-vhosts.conf

<VirtualHost *:80>
    ServerAdmin aabbott@godigitalmarketing.com
    DocumentRoot "/Users/aabbott/Sites/$repo"
    ServerName $repo.dev
    ServerAlias www.$repo.dev
    ErrorLog "/private/var/log/apache2/$repo.dev-error_log"
    CustomLog "/private/var/log/apache2/$repo.dev-access_log" common
    <Directory "/Users/aabbott/Sites/$repo">
            Options Indexes FollowSymLinks
            AllowOverride All
            Order allow,deny
            Allow from all
        </Directory>
</VirtualHost>
EOF

echo ''
echo 'Restarting server.'

sudo apachectl restart

# Section 3 - Spoof hosts for localhost redirect

echo ''
echo 'Adding spoofed domain.'
echo -e "\r127.0.0.1\t$repo.dev" >> /etc/hosts

echo ''
echo 'Do you need to setup a database?[y/n]'
read dbYesNo
if [ "$dbYesNo" = "y" ]; then
	echo "CREATE DATABASE dev_$repo" | mysql -u root -p
elif [ "$dbYesNo" = "n" ]; then
	echo 'No databse creation, moving on.'
else
	echo "Sorry, don't understand, you'll have to create it later."
fi
# Section 4 - Install WordPress using WPCLI

echo ''
echo 'Do you need to install WordPress?[y/n]'
read wordYesNo
if [ "$wordYesNo" = "y" ]; then
	cd /Users/aabbott/Sites/$repo
	wp core download --allow-root
	wp core config --dbname=dev_$repo --dbuser=root --dbpass=pass123 --allow-root
	wp core install --url=$repo.dev --title=$repo --admin_user=admin --admin_password=pass --admin_email=aabbott@godigitalmarketing.com --skip-email --allow-root
	chmod -R 755 $repo
elif [ "$wordYesNo" = "n" ]; then
	echo 'No WordPress install, moving on.'
else
	echo "Sorry, don't understand, you'll have to install it later."
	echo "You can do so using: wp core install"
fi

# Section 5 - File permission shortcuts

echo ''
echo "Fix file permissions: sudo chmod -R 755 $repo"
echo "Change owner. sudo chown -R aabbott $repo"
echo "Change owner. sudo chown -R _www $repo/wp-content/uploads"

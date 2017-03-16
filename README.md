# Setup Apache Site SHELL SCRIPT

This file when placed in the user bin folder on a linux machine runs through the various steps of setting up a site on a local LAMP install. This allows you to have numerous development sites on your local machine, reducing time to get setup to code.

Terminal command:
```
sudo setupAPsite.sh
```

If you want to name it something else, go ahead, just call the file name in short.

## Who Can Use This File?

This file assumes you have a fair understanding of a Linux system and can navigate well enough in Terminal to make manual adjustments to appropriate files. It also assumes you've already created a LAMP environment.

* Section 1 - Create new repository/site folder
* Section 2 - Create virtual host entry
* Section 3 - Spoof hosts for localhost redirect
* Section 4 - Create database
* Section 5 - Install WordPress using WPCLI
* Section 6 - File permission shortcuts

### Section 1 - Create new repository/site folder

First bit of the script will ask for the repository and site name. If I'm working on http://example.com then I'm inclined to name my repo 'example'. It takes user input with this line:
```
read repo
```
This script will work if you've already created a folder, it will ask if you want to create one. What you will need to change on your own setup is the directory path to where you are doing your development.

```
mkdir /Users/aabbott/Sites/$repo
```
Change this path to whatever is appropriate for your development environment. Leave $repo because that's the user input variable.

### Section 2 - Create virtual host entry

This is your apache config for your site development spot. The following step will be to spoof your hosts file, but when you go to your pseudo domain, this config tells apache where to direct those requests.

```
ServerAdmin email@development.com
```

Change the email address to whatever is appropriate for you.

```
    DocumentRoot "/Users/aabbott/Sites/$repo"
    ...
    <Directory "/Users/aabbott/Sites/$repo">
```

These paths will need to be changed to wherever you have your development sites.

The script then restarts apache so you won't forget.

### Section 3 - Spoof hosts for localhost redirect

This section is fairly straight forward. A new line is created in your hosts file that adds your new pseudo domain.

repo.dev

By going to whatever you called your repo with the suffix .dev in your browser, having setup apache of course, you should be able to go to that "site" now. If there's nothing in the folder, you will be met with a blank tab in your browser, but you shouldn't come across any errors.

### Section 4 - Create database

This section creates a new empty database in the format of dev_repo. You need to know your mysql password. If you want to install under a different user than root, change that here:

```
echo "CREATE DATABASE dev_$repo" | mysql -u root -p
```

Change root to whatever your preferred user name is.

If you input your password incorrectly the script won't create a new database and you'll have to sort that out later.

### Section 5 - Install WordPress using WPCLI

This section is optional if you're not using WordPress. You can change out whatever platform or framework you're using here. If you are using WordPress, you'll need to install WP CLI by going [here](http://wp-cli.org/).

Again, you'll need to change the path to wherever you have your sites setup.

```
cd /Users/aabbott/Sites/$repo
```

This will take you to your newly created folder and install WordPress.

```
wp core config --dbname=dev_$repo --dbuser=root --dbpass=tempPASSWORD --allow-root
```

This will also create a config file with your database name, user and password. Change whatever parameters are needed.

```
wp core install --url=$repo.dev --title=$repo --admin_user=admin --admin_password=pass --admin_email=email@development.com --skip-email --allow-root
```

You'll also need to add the appropriate email. This email will be the admin email for WordPress access. This also gives a password of pass - so this will also need to be changed, especially for production.

### Section 6 - File permission shortcuts

This last section just gives reference in case permissions need to be modified, because I'm a fan of copy and paste. Remember to change paths to wherever you have your site development setup.

# Documentation of Project-2
## WEB STACK IMPLEMENTATION (LEMP STACK)


## SELF STUDY
 * [SQL SYNTAX](https://docs.google.com/document/d/12_TLW5ckwtG655QisYdZr-O6aDOalokddOvjLlduaW0/edit?usp=sharing)
 * [Nano-editor](https://docs.google.com/document/d/1P9rI96eG5NH7n5UQw75-0nnRgQaC1jznqE-WCU_YYoQ/edit?usp=sharing)

### SET UP AWS ACCOUNT 
- Selected a preferred region (the closest to you) and launch a new EC2 instance of t2.micro family with Ubuntu Server 20.04 LTS (HVM)

![Alt text](images/AWS-INSTANCE-CREATION.png)

##### IMPORTANT – Save your private key (.pem file) securely and do not share it with anyone! If you lose it, you will not be able to connect to your server ever again!

- open windows terminal or git bash 

- Ensure your in the downloads folder

  ```
  cd ~/Downloads
  ```

- change permissions on your file
  ```
  sudo chmod 0400 <private-key-name>. pem
  ```

- connect to your instance by running on your terminal
  ```
  ssh -i <private-key-name>. pem ubuntu@<Public-IP-address>
  ```

![Alt text](images/ssh-connect-ubuntu.png)

 ![Alt text](images/ssh-client-connect.png) 

  ### INSTALLING THE NGINX WEB SERVER

  ```
  sudo apt update
  ```

  

![Alt text](images/nginx-install.png)

  ```
  sudo apt install nginx
 ```

![Alt text](images/nginx-install-2.png) 

- When prompted, enter Y to confirm that you want to install Nginx. Once the installation is finished, the Nginx web server will be active and running on your Ubuntu 20.04 server.

- To verify that nginx was successfully installed and is running as a service in Ubuntu, run:


 ```
 sudo systemctl status nginx
```

 ![Alt text](images/nginx-install-verify.png)

 - If it is green and running, then you did everything correctly – you have just launched your first Web Server in the Clouds!

- If it is green and running, then you did everything correctly – you have just launched your first Web Server in the Clouds!
- Before we can receive any traffic by our Web Server, we need to open TCP port 80 which is default port that web browsers use to access web pages in the Internet.
- As we know, we have TCP port 22 open by default on our EC2 machine to access it via SSH, so we need to add a rule to EC2 configuration to open inbound connection through port 80:

- Our server is running and we can access it locally and from the Internet (Source 0.0.0.0/0 means ‘from any IP address’).

- First, let us try to check how we can access it locally in our Ubuntu shell, run:

```
curl http://localhost:80
```

or

```
curl http://127.0.0.1:80
```

![Alt text](images/curl-nginxworking.png)

- These 2 commands above actually do pretty much the same – they use ‘curl’ command to request our Nginx on port 80 (actually you can even try to not specify any port – it will work anyway). The difference is that: in the first case we try to access our server via DNS name and in the second one – by IP address (in this case IP address 127.0.0.1 corresponds to DNS name ‘localhost’ and the process of converting a DNS name to IP address is called "resolution"). 

- Open a web browser of your choice and try to access following url


```
http://<Public-IP-Address>:80
```


- Another way to retrieve your Public IP address, other than to check it in AWS Web console, is to use following command:

```
curl -s http://169.254.169.254/latest/meta-data/public-ipv4
```
-- This will not work anymore due to aws new security policies read on Metadata and IMDV2.This is the new waw to retrieve your Public IP address

```
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` 
curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/public-ipv4

```
![Alt text](images/public-ip-retrieve.png)


![Alt text](images/nginx-working.png)
- The URL in browser shall also work if you do not specify port number since all web browsers use port 80 by default.

###  INSTALLING MYSQL
 - Now that you have a web server up and running, you need to install a Database Management System (DBMS) to be able to store and manage data for your site in a relational database. MySQL is a popular relational database management system used within PHP environments

 ```
sudo apt install mysql-server
 ```

![Alt text](images/my-sql-instal.png)

 When prompted, confirm installation by typing Y, and then ENTER.When the installation is finished, log in to the MySQL console by typing:

```
sudo mysql
```

![Alt text](images/mysql-login.png)

- It’s recommended that you run a security script that comes pre-installed with MySQL. This script will remove some insecure default settings and lock down access to your database system. Before running the script, you will set a password for the root user, using mysql_native_password as default authentication method. We’re defining this user’s password as PassWord.1.


```
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'PassWord.1'
```

![Alt text](images/change-password.png)

- Exit the MySQL shell with:

``` 
exit
```

Start the interactive script by running:

```
sudo mysql_secure_installation
```

![Alt text](images/secure-installation.png)

-This will ask if you want to configure the VALIDATE PASSWORD PLUGIN.

 ##### Note: Enabling this feature is something of a judgment call. If enabled, passwords which don’t match the specified criteria will be rejected by MySQL with an error. It is safe to leave validation disabled, but you should always use strong, unique passwords for database credentials.

- Answer Y for yes, or anything else to continue without enabling.

  - VALIDATE PASSWORD PLUGIN can be used to test passwords and improve security. It checks the strength of password and allows the users to set  only those passwords which are secure enough. 
```
     Would you like to setup VALIDATE PASSWORD plugin?
    Press y|Y for Yes, any other key for No:
```

If you answer “yes”, you’ll be asked to select a level of password validation. Keep in mind that if you enter 2 for the strongest level, you will receive errors when attempting to set any password which does not contain numbers, upper and lowercase letters, and special characters, or which is based on common dictionary words e.g PassWord.1.
There are three levels of password validation policy:
 
    LOW	Length >= 8
    MEDIUM Length >= 8, numeric, mixed case, and special characters
    STRONG Length >= 8, numeric, mixed case, special characters and dictionary file 
 
    Please enter 0 = LOW, 1 = MEDIUM and 2 = STRONG: 1COPY
- Regardless of whether you choose to set up the VALIDATE PASSWORD PLUGIN, your server will next ask you to select and confirm a password for the MySQL root user. This is not to be confused with the system root. The database root user is an administrative user with full privileges over the database system. Even though the default authentication method for the MySQL root user dispenses the use of a password, even when one is set, you should define a strong password here as an additional safety measure. We’ll talk about this in a moment.

- If you enabled password validation, you’ll be shown the password strength for the root password you just entered and your server will ask if you want to continue with that password. If you are happy with your current password, enter Y for “yes” at the prompt:
  
```

    Estimated strength of the password: 100

    Do you wish to continue with the password provided? (Press y|Y for Yes, any other key for No): y
```

- For the rest of the questions, press Y and hit the ENTER key at each prompt. This will prompt you to change the root password, remove some anonymous users and the test database, disable remote root logins, and load these new rules so that MySQL immediately respects the changes you have made.
When you’re finished, test if you’re able to log in to the MySQL console by typing:


 ```
 sudo mysql -p
```

![Alt text](images/password-test.png)

- For increased security, it’s best to have dedicated user accounts with less expansive privileges set up for every database, especially if you plan on having multiple databases hosted on your server.
- Note: At the time of this writing, the native MySQL PHP library mysqlnd doesn’t support caching_sha2_authentication, the default authentication method for MySQL 8. For that reason, when creating database users for PHP applications on MySQL 8, you’ll need to make sure they’re configured to use mysql_native_password instead. 


- Your MySQL server is now installed and secured. Next, we will install PHP, the final component in the LEMP stack.

####  INSTALLING PHP
- You have Nginx installed to serve your content and MySQL installed to store and manage your data. Now you can install PHP to process code and generate dynamic content for the web server.
- While Apache embeds the PHP interpreter in each request, Nginx requires an external program to handle PHP processing and act as a bridge between the PHP interpreter itself and the web server. This allows for a better overall performance in most PHP-based websites, but it requires additional configuration. You’ll need to install php-fpm, which stands for “PHP fastCGI process manager”, and tell Nginx to pass PHP requests to this software for processing. Additionally, you’ll need php-mysql, a PHP module that allows PHP to communicate with MySQL-based databases. Core PHP packages will automatically be installed as dependencies.

```
sudo apt install php-fpm php-mysql
```

![Alt text](images/php-install.png)

- When prompted, type Y and press ENTER to confirm installation.
You now have your PHP components installed. Next, you will configure Nginx to use them.

####  CONFIGURING NGINX TO USE PHP PROCESSOR
- When using the Nginx web server, we can create server blocks (similar to virtual hosts in Apache) to encapsulate configuration details and host more than one domain on a single server. In this guide, we will use project LEMP as an example domain name.
- On Ubuntu 20.04, Nginx has one server block enabled by default and is configured to serve documents out of a directory at /var/www/html. While this works well for a single site, it can become difficult to manage if you are hosting multiple sites. Instead of modifying /var/www/html, we’ll create a directory structure within /var/www for your domain website, leaving /var/www/html in place as the default directory to be served if a client request does not match any other sites.
Create the root web directory for your domain as follows:

```
sudo mkdir /var/www/projectLEMP
```

- Next, assign ownership of the directory with the $USER environment variable, which will reference your current system user:

```
sudo chown -R $USER:$USER /var/www/projectLEMP
```

- Then, open a new configuration file in Nginx’s sites-available directory using your preferred command-line editor.
 ```
sudo vi /etc/nginx/sites-available/projectLEMP
```

 - This will create a new blank file. Paste in the following bare-bones configuration
```
    #/etc/nginx/sites-available/projectLEMP
 
    server {
	listen 80;
	server_name projectLEMP www.projectLEMP;
	root /var/www/projectLEMP;
 
	index index.html index.htm index.php;
 
	location / {
    	try_files $uri $uri/ =404;
	}
 
	location ~ \.php$ {
    	include snippets/fastcgi-php.conf;
    	fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
 	}
 
	location ~ /\.ht {
    	deny all;
	}
 
    }

```
 ### Here’s what each of these directives and location blocks do:
* listen — Defines what port Nginx will listen on. In this case, it will listen on port 80, the default port for HTTP.
  
* root — Defines the document root where the files served by this website are stored.
  
* index — Defines in which order Nginx will prioritize index files for this website. It is a common practice to list index.html files with a higher precedence than index.php files to allow for quickly setting up a maintenance landing page in PHP applications. You can adjust these settings to better suit your application needs.

 * server_name — Defines which domain names and/or IP addresses this server block should respond for. Point this directive to your server’s domain name or public IP address.
 
 * location / — The first location block includes a try_files directive, which checks for the existence of files or directories matching a URI request. If Nginx cannot find the appropriate resource, it will return a 404 error.
 
 * location ~ \.php$ — This location block handles the actual PHP processing by pointing Nginx to the fastcgi-php.conf configuration file and the php7.4-fpm.sock file, which declares what socket is associated with php-fpm.
 
 * location ~ /\.ht — The last location block deals with .htaccess files, which Nginx does not process. By adding the deny all directive, if any .htaccess files happen to find their way into the document root, they will not be served to visitors.
  

- When you’re done editing, save and close the file. If you’re using nano, you can do so by typing CTRL+X and then y and ENTER to confirm.

- Activate your configuration by linking to the config file from Nginx’s sites-enabled directory:

 ```
 sudo ln -s /etc/nginx/sites-available/projectLEMP /etc/nginx/sites-enabled/
```

- This will tell Nginx to use the configuration next time it is reloaded. You can test your configuration for syntax errors by typing:

```
sudo nginx -t
```

![Alt text](images/nginx-test.png)

- If any errors are reported, go back to your configuration file to review its contents before continuing.

- We also need to disable default Nginx host that is currently configured to listen on port 80, for this run:

```
sudo unlink /etc/nginx/sites-enabled/default
```

- Reload Nginx to apply the changes

```
sudo systemctl reload nginx
```

- Your new website is now active, but the web root /var/www/projectLEMP is still empty. Create an index.html file in that location so that we can test that your new server block works as expected:

 ```
 touch index.html
```

```
sudo echo 'Hello LEMP from hostname' $(TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` 
curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/public-hostname) 'with public IP' $(TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` 
curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/public-ipv4) > /var/www/projectLEMP/index.html
```

 - open your website URL using IP address:

 ```
 http://<Public-IP-Address>:80
```

 or

```
http://<Public-DNS-Name>:80
```

- If you see the text from ‘echo’ command you wrote to index.html file, then it means your Nginx site is working as expected. In the output you will see your server’s public hostname (DNS name) and public IP address. You can also access your website in your browser by public DNS name, not only by IP – try it out, the result must be the same (port is optional)

 ![Alt text](images/hello-lemp.png)

- You can leave this file in place as a temporary landing page for your application until you set up an index.php file to replace it. Once you do that, remember to remove or rename the index.html file from your document root, as it would take precedence over an index.php file by default.
Your LEMP stack is now fully configured. In the next step, we’ll create a PHP script to test that Nginx is in fact able to handle .php files within your newly configured website.

### TESTING PHP WITH NGINX
Your LEMP stack should now be completely set up.
You can test it to validate that Nginx can correctly hand .php files off to your PHP processor.
You can do this by creating a test PHP file in your document root. Open a new file called info.php within your document root in your text editor:

```
sudo nano /var/www/projectLEMP/info.php
```

Type or paste the following lines into the new file. This is valid PHP code that will return information about your server:

![Alt text](images/php-file1.png)

You can now access this page in your web browser by visiting the domain name or public IP address you’ve set up in your Nginx configuration file, followed by /info.php:

```
http://`server_domain_or_IP`/info.php
```

![Alt text](images/php-file2.png)

After checking the relevant information about your PHP server through that page, it’s best to remove the file you created as it contains sensitive information about your PHP environment and your Ubuntu server. You can use rm to remove that file:

```
sudo rm /var/www/your_domain/info.php
```

You can always create this file later

### RETRIEVING DATA FROM MYSQL DATABASE WITH PHP 

- you will create a test database (DB) with simple "To do list" and configure access to it, so the Nginx website would be able to query data from the DB and display it.
At the time of this writing, the native MySQL PHP library mysqlnd doesn’t support caching_sha2_authentication, the default authentication method for MySQL 8. We’ll need to create a new user with the mysql_native_password authentication method in order to be able to connect to the MySQL database from PHP.

- We will create a database named example_database and a user named example_user, but you can replace these names with different values.
First, connect to the MySQL console using the root account:

`sudo mysql -p`

![Alt text](images/login-again.png)


`CREATE DATABASE `example_database`;`

![Alt text](images/Database-creation.png)

- Now you can create a new user and grant him full privileges on the database you have just created.
The following command creates a new user named example_user, using mysql_native_password as default authentication method. We’re defining this user’s password as password, but you should replace this value with a secure password of your own choosing.


` CREATE USER 'example_user'@'%' IDENTIFIED WITH mysql_native_password BY 'password';`

- Now we need to give this user permission over the example_database database:

`GRANT ALL ON example_database.* TO 'example_user'@'%';`

- This will give the example_user user full privileges over the example_database database, while preventing this user from creating or modifying other databases on your server.

`exit`

- You can test if the new user has the proper permissions by logging in to the MySQL console again, this time using the custom user credentials:

`mysql -u example_user -p`

![Alt text](images/login%20new%20user.png)

- Notice the -p flag in this command, which will prompt you for the password used when creating the example_user user. After logging in to the MySQL console, confirm that you have access to the example_database database:

 `SHOW DATABASES;`

 - Next, we’ll create a test table named todo_list. From the MySQL console, run the following statement:

 ` CREATE TABLE example_database.todo_list (item_id INT AUTO_INCREMENT,content VARCHAR(255),PRIMARY KEY(item_id) );`

![Alt text](images/create-table.png) 

- Insert a few rows of content in the test table. You might want to repeat the next command a few times, using different VALUES:

`INSERT INTO example_database.todo_list (content) VALUES ("My first important item");`

`INSERT INTO example_database.todo_list (content) VALUES ("My second important item");`

- To confirm that the data was successfully saved to your table, run:

` SELECT * FROM example_database.todo_list;`

- After confirming that you have valid data in your test table, you can exit the MySQL console:

- Now you can create a PHP script that will connect to MySQL and query for your content. Create a new PHP file in your custom web root directory using your preferred editor. We’ll use vi for that:

`nano /var/www/projectLEMP/todo_list.php`

![Alt text](images/last-nano-login.png)

- The following PHP script connects to the MySQL database and queries for the content of the todo_list table, displays the results in a list. If there is a problem with the database connection, it will throw an exception.
Copy this content into your todo_list.php script:

```
     <?php
     $user = "example_user";
     $password = "password";
     $database = "example_database";
     $table = "todo_list";
 
     try {
          $db = new PDO("mysql:host=localhost;dbname=$database", $user, $password);
     echo "<h2>TODO</h2><ol>";
     foreach($db->query("SELECT content FROM       $table") as $row) {
	 echo "<li>" . $row['content'] . "</li>";
     }
    echo "</ol>";
    } catch (PDOException $e) {
	 print "Error!: " . $e->getMessage() . "<br/>";
	 die();
    }

```
- Save and close the file when you are done editing.
- You can now access this page in your web browser by visiting the domain name or public IP address configured for your website, followed by /todo_list.php:

`http://<Public_domain_or_IP>/todo_list.php`

- You should see a page like this, showing the content you’ve inserted in your test table:

![Alt text](images/TO-DO%20-FILE.png)

- That means your PHP environment is ready to connect and interact with your MySQL server.

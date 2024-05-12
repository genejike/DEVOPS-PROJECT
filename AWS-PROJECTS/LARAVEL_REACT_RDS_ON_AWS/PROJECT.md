### Hosting  a laravel and react application an 2 aws ec2 instances
#### frontend -react 
- create an amazon ec2 and amazon rds and configure them 
- copy your already existing code for the application into the instance
- Download the file from git 
- on your local instance run
  ```sh
  scp -i example.pem -r folder/* ubuntu@ipaddress:/home/ubuntu/
  ```
- or use git to transfer the files
- 
cd into the frontend folder and run 
```
npm install
or
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash -
sudo apt-get install -y nodejs
```
- install vite if your using vite to install it globally 
```
   sudo npm install -g vite
   npm install vite --save-dev

```
- check you /src/utils/apicontant.js file
to ensure that its connecting to the correct backend url

```
cd ~
npm run build
```

- install nginx
```
sudo apt install nginx 
```
```
  cd /etc/nginx/sites-available/
```
- create a folder  eg example and paste and edit accordingly

```
server {
    listen 80;
    listen [::]:80;
    server_name example.com;
    root /srv/example.com/public;
 
    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff";
 
    index index.php;
 
    charset utf-8;
 
    location / {

                root /var/www/html/dist;
                index index.html;
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri /index.html$is_args$args =404;
        
    }
 
    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }
 
    error_page 404 /index.php;
 
    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
    }
 
    location ~ /\.(?!well-known).* {
        deny all;
    }
}
```
- create a systemlink 
```
sudo ln -s /etc/nginx/sites-available/your_config_file /etc/nginx/sites-enabled/

```
- cd  into frontend folder/ and run
```
- sudo cp -r build/* /var/www/html
or
- sudo cp -r dist/* /var/www/html  ##if your using vite 
```

####  Backend configuration

 on your second instance input your backend folder
-install php and its dependencies 
```
sudo apt update
sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt install php8.3-cli php8.2-common php8.3-mysql php8.3-zip php8.3-gd php8.3-mbstring php8.3-curl php8.3-xml php8.3-bcmath php8.3-fpm
sudo apt install php8.3-dom
sudo apt install php8.3-xml
sudo apt install php8.3-curl
sudo apt install php8.3-mysql
sudo apt install php-mbstring
sudo systemctl restart php8.3-fpm

```

```

## visit official composer website download section
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

```

```
curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer

```
- run sudo vi .env and configure your input variables
- or cp .env.example .env 
- create your rds instance and connect it to your ec2 machine
  
- add you .env files
in your backend folder
```
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=my-database 
DB_USERNAME=root
DB_PASSWORD=

BROADCAST_DRIVER=log
CACHE_DRIVER=file
FILESYSTEM_DISK=local
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120

MEMCACHED_HOST=127.0.0.1

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

# MAIL_MAILER=smtp
# MAIL_HOST=mailpit
# MAIL_PORT=1025
# MAIL_USERNAME=null
# MAIL_PASSWORD=null
# MAIL_ENCRYPTION=null
# MAIL_FROM_ADDRESS="hello@example.com"
# MAIL_FROM_NAME="${APP_NAME}"

MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=465
MAIL_USERNAME=venioeapp@gmail.com
MAIL_PASSWORD=kzvzohszhsognjwu
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=venioeapp@gmail.com
MAIL_FROM_NAME="venioe"


# MAIL_MAILER=smtp
# MAIL_HOST=sandbox.smtp.mailtrap.io
# MAIL_PORT=2525
# MAIL_USERNAME=41c2ab3750ea8f
# MAIL_PASSWORD=16dc8d57a9bcd3

AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=
AWS_USE_PATH_STYLE_ENDPOINT=false

PUSHER_APP_ID=
PUSHER_APP_KEY=
PUSHER_APP_SECRET=
PUSHER_HOST=
PUSHER_PORT=443
PUSHER_SCHEME=https
PUSHER_APP_CLUSTER=mt1

VITE_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
VITE_PUSHER_HOST="${PUSHER_HOST}"
VITE_PUSHER_PORT="${PUSHER_PORT}"
VITE_PUSHER_SCHEME="${PUSHER_SCHEME}"
VITE_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"
```

- run
```
composer update
composer upgrade

php artisan optimize
 php artisan db:seed
php artisan migrate
php artisan passport:keys
php artisan passport:install

 
```
- install nginx and configure your nginx.conf default file
  ```
  server {
      listen 80;
      server_name localhost;
      root /var/www/html/demo/public;

      add_header X-Frame-Options "SAMEORIGIN";
      add_header X-Content-Type-Options "nosniff";

      index index.php;

      charset utf-8;

      location / {
             try_files $uri $uri/ /index.php?$query_string;
      }

       location = /favicon.ico { access_log off; log_not_found off; }
       location = /robots.txt  { access_log off; log_not_found off; }

       error_page 404 /index.php;

       location ~ \.php$ {
            fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
            fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
            include fastcgi_params;
        }

       location ~ /\.(?!well-known).* {
          deny all;
       }
  }
  ```
```
cp -r api /var/www/html
cd api
sudo systemctl restart nginx
chmod -R 775 /var/www/html/api/storage
chown -R www-data:www-data /var/www/html/api/storage
sudo chown www-data /home/ubuntu/Venioe/api/storage/logs

sudo chown www-data:www-data /home/ubuntu/Venioe/api/storage/logs/laravel.log
sudo chown -R www-data:www-data /home/ubuntu/Venioe/api/storage/framework/sessions
sudo chown -R www-data:www-data /home/ubuntu/Venioe/api/storage/framework/views

```
- test your website

inorder to forward the port to port 443 
use certbot on nginx for testing purposes 


Resources
- [chatgpt conversations ](https://chat.openai.com/share/1f88dfe8-1e7e-4d44-8394-f1c0e159885c)
- [Deploying a React Application with Nginx on Ubuntu ](https://www.youtube.com/watch?v=WKfmhgYQlCM )
- [How to deploy a Laravel application on Amazon EC2](https://www.youtube.com/watch?v=flQ-KtaV6HU&t=1304s)
- [Deploy laravel app to aws with database rds ](https://www.youtube.com/watch?v=OTVocNuqFT8&t=18s)
- https://www.bacancytechnology.com/blog/deploy-laravel-application-on-aws-ec2#technical-stack:-deploy-laravel-application-on-aws-ec2

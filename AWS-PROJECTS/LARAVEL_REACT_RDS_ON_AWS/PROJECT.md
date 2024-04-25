### Hosting  a laravel and react application an aws ec2 
- create an amazon ec2 and amazon rds and configure them 
- copy your already existing code for the application into the instance
- download the file from git 
- on your local instance run
  ```sh
  scp -i example.pem -r folder/* ubuntu@ipaddress:/home/ubuntu/
  ```
- or use git to transfer the files
- 
cd into the frontend folder and
```
run npm install
or
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash -
sudo apt-get install -y nodejs
```
- install vite if your using vite to install it globally 
```
   sudo npm install -g vite
   npm install vite --save-dev

```
check you /src/utils/apicontant.js file
to ensure that its connecting to the  correct backend url
```
cd ~
npm run build
```
- install nginx
-
```
  cd /etc/nginx/sites-available/
```
- create a folder and paste and edit accordinly

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
        try_files $uri $uri/ /index.php?$query_string;
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
```
sudo ln -s /etc/nginx/sites-available/your_config_file /etc/nginx/sites-enabled/

```
- cd frontend folder/ and run
```
- sudo cp -r build/* /var/www/html
or
- sudo cp -r dist/* /var/www/html  ##if your using vite 
```

###  Backend configuration

cd into backend folder

- run composer install
```
visit official composer website download section


```
- run sudo vi .env and configure your input variables

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

php artisan passport:install

php artisan serve --hosts=ipaddress 
```

Resources
- [chatgpt conversations ](https://chat.openai.com/share/1f88dfe8-1e7e-4d44-8394-f1c0e159885c)
- [Deploying a React Application with Nginx on Ubuntu ](https://www.youtube.com/watch?v=WKfmhgYQlCM )
- [How to deploy a Laravel application on Amazon EC2](https://www.youtube.com/watch?v=flQ-KtaV6HU&t=1304s)
- [Deploy laravel app to aws with database rds ](https://www.youtube.com/watch?v=OTVocNuqFT8&t=18s)

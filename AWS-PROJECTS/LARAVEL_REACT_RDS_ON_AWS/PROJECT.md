### Hosting  a laravel and react application an aws ec2 

- copy your already existing code for the application into the instance
- download the file from git 
- on your local instance run
  ```
  scp -i example.pem -r folder/* ubuntu@ipaddress:/home/ubuntu/
  ```
- or use git to transfer the files 
cd into the frontend folder and
run npm install or
```
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash -
sudo apt-get install -y nodejs
```
- install vite if your using vite to install it globally 
  ```
   sudo npm install -g vite
```
check you /src/utils/apicontant.js file
to ensure that its connecting to the  correct backend url
- next run npm install
- npm run build
- install nginx
- cd /etc/nginx/sites-available/
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

-sudo ln -s /etc/nginx/sites-available/venioe /etc/nginx/sites-enabled/
go back to your frontend folder and run 
- sudo cp -r build/* /var/www/html
or
- sudo cp -r vite/* /var/www/html  if your using vite 

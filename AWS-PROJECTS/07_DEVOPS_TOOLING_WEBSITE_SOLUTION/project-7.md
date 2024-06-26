### DEVOPS TOOLING WEBSITE SOLUTION
 
##### Technology specification

- cloud: AWS
- Webserver Linux: Red Hat Enterprise Linux 8

- Database Server: Ubuntu 20.04 + MySQL

- Storage Server: Red Hat Enterprise Linux 8 + NFS Server

- Programming Language: PHP

- Code Repository: GitHub

On the diagram below there is a common pattern where several stateless Web Servers share a common database and also access the same files using Network File Sytem (NFS) as a shared file storage. 
![image](https://github.com/genejike/DEVOPS-PROJECT/assets/75420964/415a4359-7308-4cf9-b222-97eefceb258d)


It is important to know what storage solution is suitable for your use cases,
here are sample questions to ask before picking a suitable storage solution.

- what data will be stored,
- in what format,
- how this data will be accessed, by whom, from where, how frequently, etc. B
 

# STEP 1 – PREPARE NFS SERVER


* Spin up a new EC2 instance with RHEL Linux 8 Operating System.
![image](https://github.com/genejike/DEVOPS-PROJECT/assets/75420964/857e32a5-f215-4368-9d8e-4d230ab8beb4)

* Configure LVM on the Server.

* Create 3 volumes in the same AZ as your Web Server EC2, each of 10 GiB.

* Attach all 3 volumes to your NFSserver.

* use `lsblk` to see what blocked device are attached on the server and `df-h` to see the mounted volumes and free space 

![image](https://github.com/genejike/DEVOPS-PROJECT/assets/75420964/c8ea2a21-dbd5-4533-a664-647460b01d22)

Use gdisk utility to create a single partition on each of the 3 disks
```sh
sudo gdisk /dev/xvdf
```
```sh
sudo gdisk /dev/xvdh
```
```sh
sudo gdisk /dev/xvdg
```
During the partition creation:
- For the partition number click 1.

- for the first sector and last sector  hit enter ,

- click enter since we are using the whole disk space,

- we are using lvm we change to the partition type 8E00

Use the `lsblk` utility to view the newly configured partition on each of the 3 disks.

* Install lvm2 package using

```sh
sudo yum install lvm2.
```

* Run `sudo lvmdiskscan` command to check for available partitions.

* Use pvcreate utility to mark each of 3 disks as physical volumes (PVs) to be used by LVM
```sh
sudo pvcreate /dev/xvdf1 
sudo pvcreate /dev/xvdg1 
sudo pvcreate /dev/xvdh1

```
* use `sudo pvs` to see the physical volumes created 

* Use vgcreate utility to add all 3 PVs to a volume group (VG). Name the VG nfsdata-vg
```sh
sudo vgcreate nfsdata-vg /dev/xvdh1 /dev/xvdg1 /dev/xvdf1
```

* Verify that your VG has been created successfully by running

`sudo vgs`
![image](https://github.com/genejike/DEVOPS-PROJECT/assets/75420964/eaa2aa19-8376-4153-9e03-bb5b59f97dab)

* Use lvcreate utility to create 3 Logical Volumes. 
- lv-opt lv-apps, and lv-logs
```sh
sudo lvcreate -n lv-apps -L 9G nfsdata-vg 
sudo lvcreate -n lv-logs -L 9G nfsdata-vg
sudo lvcreate -n lv-opt -L 9G nfsdata-vg

```
* Verify that your Logical Volume has been created successfully by running

`sudo lvs`

* Verify the entire setup

`sudo vgdisplay -v #view complete setup - VG, PV, and LV `
![image](https://github.com/genejike/DEVOPS-PROJECT/assets/75420964/f2eb0507-633c-460a-b28d-3c4d1e8ee3a8)

` sudo lsblk `

* Use mkfs.xfs to format the logical volumes with xfs filesystem
```sh
sudo mkfs -t xfs /dev/nfsdata-vg/lv-apps 
sudo mkfs -t xfs /dev/nfsdata-vg/lv-logs
sudo mkfs -t xfs /dev/nfsdata-vg/lv-opt 

```
* Create mount points on /mnt directory for the logical volumes as follow:

- Mount lv-apps on /mnt/apps – To be used by webservers

- Mount lv-logs on /mnt/logs – To be used by webserver logs

- Mount lv-opt on /mnt/opt – To be used by Jenkins server in Project 8


* Create /mnt/apps directory to store website files

```sh
sudo mkdir -p /mnt/apps
sudo mkdir -p /mnt/logs
sudo mkdir -p /mnt/opt
```
* Mount /mnt/apps on lv-apps logical volume

```sh
sudo mount /dev/nfsdata-vg/lv-apps /mnt/apps

```
* Use rsync utility to back up all the files in the log directory /var/log into /mnt/logs (This is required before mounting the file system)
```sh
sudo rsync -av /mnt/logs/. /var/log
```

* Mount /mnt/log on lv-logs logical volume. (Note that all the existing data on /mnt/log will be deleted.)

```sh
sudo mount /dev/nfsdata-vg/lv-logs /mnt/logs
```
* Restore log files back into /mnt/log directory
```sh
sudo rsync -av /mnt/logs/. /var/log
```

* Update the  /etc/fstab file
```sh
sudo blkid 
```
```sh
sudo vi /etc/fstab

```

* insert the uuid for the 3 nfsdata-vg created
  ![image](https://github.com/genejike/DEVOPS-PROJECT/assets/75420964/2ce160cb-41cb-474d-9bfb-1eac153dd87a)

* Test the configuration and reload the daemon

```sh
sudo mount -a
sudo systemctl daemon-reload
```

* Install NFS server, configure it to start on reboot and make sure it is up and running

```sh
sudo yum update -y 
sudo yum install nfs-utils -y
sudo systemctl start nfs-server.service
sudo systemctl enable nfs-server.service
sudo systemctl status nfs-server.service

```
![image](https://github.com/genejike/DEVOPS-PROJECT/assets/75420964/e185cf8d-566d-4c7b-9960-0f05cce3d854)

- Export the mounts for webservers’ subnet CIDR to connect as clients.
* For simplicity, install all three Web Servers inside the same subnet, but in the production set-up, you would probably want to separate each tier inside its own subnet for a higher level of security.

To check your subnet cidr – open your EC2 details in the AWS web console and locate the ‘Networking’ tab and open a Subnet link

* Make sure we set up permission that will allow our Web servers to read, write and execute files on NFS:
```sh
sudo chown -R nobody: /mnt/apps
sudo chown -R nobody: /mnt/logs
sudo chown -R nobody: /mnt/opt
 
sudo chmod -R 777 /mnt/apps
sudo chmod -R 777 /mnt/logs
sudo chmod -R 777 /mnt/opt
 ```
```sh
sudo systemctl restart nfs-server.service
```
* Configure access to NFS for clients within the same subnet (example of Subnet CIDR – 172.31.80.0/20):

```sh
sudo vi /etc/exports
```
``` sh
/mnt/apps <Subnet-CIDR>(rw,sync,no_all_squash,no_root_squash)
/mnt/logs <Subnet-CIDR>(rw,sync,no_all_squash,no_root_squash)
/mnt/opt <Subnet-CIDR>(rw,sync,no_all_squash,no_root_squash)
``` 
``` sh
sudo exportfs -arv
```

![image](https://github.com/genejike/DEVOPS-PROJECT/assets/75420964/d315a9ba-015f-4c7d-9f32-f1942491ebde)

* Check which port is used by NFS and open it using Security Groups (add new Inbound Rule)
```sh
rpcinfo -p | grep nfs
```
![image](https://github.com/genejike/DEVOPS-PROJECT/assets/75420964/ec3fe7c1-77e1-48c2-beac-3dbaebe3a3fe)

* Important note: In order for NFS server to be accessible from your client, you must also open following ports:
  - TCP 111, UDP 111, UDP 2049,TCP 2049
![image](https://github.com/genejike/DEVOPS-PROJECT/assets/75420964/e6af110e-fc45-4c41-9f36-b7807e64f123)



### STEP 2 — CONFIGURE THE DATABASE SERVER

#### Install and configure a MySQL DBMS to work with remote Web Server

*  Update ubuntu
 
```sh
sudo apt update 
```

* Upgrade ubuntu 
```sh
sudo apt upgrade -y
```
* Install MySQL Server

```sh
sudo apt install mysql-server -y
```
* Start server

```sh
sudo systemctl enable mysql
```
* Check the status to ensure it is running

```sh
sudo systemctl status mysql
```

* First, open up the MySQL prompt:

``` 
sudo mysql
```

* Change the root user’s authentication method to one that uses a password.

```sh
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
```

* exit the MySQL prompt:`exit`

Run this to set up secure installation

```
sudo mysql_secure_installation
```
* Login to MySQL
```sh
sudo mysql -u root -p
```
* Create a database and name it tooling

```sh
create database tooling;
```
* Create a database user and name it webaccess
* Create new user and replace % with the ipv4 cidr for webserver
```sh
CREATE USER 'webaccess'@'172.31.42.148' IDENTIFIED WITH mysql_native_password BY 'Password@123';
```
* Grant permission to webaccess user on tooling database to do anything only from the webservers subnet cidr

```sh
GRANT ALL PRIVILEGES ON tooling.* TO 'webaccess'@'%' WITH GRANT OPTION;

FLUSH PRIVILEGES;
```
<img width="482" alt="change on tooling" src="https://github.com/genejike/DEVOPS-PROJECT/assets/75420964/1c3f61ce-a7e7-4a76-a731-34a612e09af3">

```sh
sudo systemctl restart mysql
```

### Step 3 — Prepare the Web Servers

* We need to make sure that our Web Servers can serve the same content from shared storage solutions, in our case – NFS Server and MySQL database.

* You already know that one DB can be accessed for reads and writes by multiple clients. For storing shared files that our Web Servers will use – we will utilize NFS and mount previously created Logical Volume lv-apps to the folder where Apache stores files to be served to the users (/var/www).

* This approach will make our Web Servers stateless, which means we will be able to add new ones or remove them whenever we need, and the integrity of the data (in the database and on NFS) will be preserved.

* During the next steps we will do following:

1.Configure NFS client (this step must be done on all three servers)

2.Deploy a Tooling application to our Web Servers into a shared NFS folder

3.Configure the Web Servers to work with a single MySQL database

* Launch a new EC2 instance with RHEL 8 Operating System
* Install NFS client

```sh
sudo yum install nfs-utils nfs4-acl-tools -y
```
Mount /var/www/ and target the NFS server’s export for apps

```sh
sudo mkdir /var/www
```

```sh
sudo mount -t nfs -o rw,nosuid <NFS-Server-Private-IP-Address>:/mnt/apps /var/www
```

- Verify that NFS was mounted successfully by running `df -h`. 

- Make sure that the changes will persist on Web Server after reboot:

```sh
sudo vi /etc/fstab
```
- Add following line
  
```sh
<NFS-Server-Private-IP-Address>:/mnt/apps /var/www nfs defaults 0 0
```
* Install Remi’s repository, Apache and PHP

```sh
sudo yum install httpd -y
 
sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
 
sudo dnf install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm
 
sudo dnf module reset php
 
sudo dnf module enable php:remi-7.4
 
sudo dnf install php php-opcache php-gd php-curl php-mysqlnd
 
sudo systemctl start php-fpm
 
sudo systemctl enable php-fpm
 
sudo setsebool -P httpd_execmem 1

```

Repeat steps 1-5 for another 2 Web Servers.

1.Verify that Apache files and directories are available on the Web Server in /var/www and also on the NFS server in /mnt/apps.
![image](https://github.com/genejike/DEVOPS-PROJECT/assets/75420964/dc93acab-c45f-4269-aa49-d0f92ee8725b)
     ![image](https://github.com/genejike/DEVOPS-PROJECT/assets/75420964/4b1b8b86-fc73-4798-b0ed-51bb318a2905)
2.If you see the same files – it means NFS is mounted correctly. You can try to create a new file touch test.txt in the /var/www path from one server and check if the same file is accessible from other Web Servers.

3.Locate the log folder for Apache on the Web Server and mount it to NFS server’s export for logs. 
  Repeat step №4 to make sure the mount point will persist after reboot.
 ```sh
 sudo mount -t nfs -o rw,nosuid 172.31.80.202:/mnt/logs /var/log/httpd
```

* Fork the tooling source code from [darey.io](https://github.com/darey-io/tooling)
* install git and clone 
  ```sh
  sudo yum install git
  git init 
  git clone https://github.com/darey-io/tooling
  
  ```
  

* Deploy the tooling website’s code to the Webserver. Ensure that the html folder from the repository is deployed to /var/www/html
  
```
cd tooling 
sudo cp -R html/. /var/www/html
```
* Note 1: Do not forget to open TCP port 80 on the Web Server.
* Note 2: If you encounter 403 Error – check permissions to your /var/www/html folder and also disable SELinux 
```
sudo setenforce 0
```

To make this change permanent – open following config file 
```
sudo vi /etc/sysconfig/selinux
```
and 
- set `SELINUX=disabled`then restart httpd.
  
-Update the website’s configuration to connect to the database (in /var/www/html/functions.php file).

![image](https://github.com/genejike/DEVOPS-PROJECT/assets/75420964/7464e43d-f99c-429a-aa7a-1fc698a105e1)

* install my sql client
  ```
  sudo yum install mysql
  ```
Apply tooling-db.sql script to your database using this command
```
cd tooling
```
```sh
mysql -h <databse-private-ip> -u <db-username> -p <db-name> < tooling-db.sql
```
if it does not work check out the bind address on the database  server buy running 

```
 sudo vi /etc/mysql/mysql.conf.d/mysqld.cnf
```
edit the  2 bind address to the ip address or cidr block of the web servers
id be using 0.0.0.0 for simplicity but for security reasons limit it 

![image](https://github.com/genejike/DEVOPS-PROJECT/assets/75420964/ad65ca96-b000-4914-8f3f-4a732019ffb1)

Also check if port 3306 is open on the database server

- confirm if this worked by logining to your database with the username created 
```
mysql -h <ip address of the database> -u webaccess -p tooling

```

```
use tooling;
show tables;
select * from users;

```
* click exit 
* login as the root user 
* Create in MySQL a new admin user with username: myuser and password: password:
  
```sh
INSERT INTO `users` (`id`, `username`, `password`, `email`, `user_type`, `status`) VALUES
(1, 'myuser', '5f4dcc3b5aa765d61d8327deb882cf99', 'user@mail.com', 'admin', '1');
```
* Open the website in your browser http://<Web-Server-Public-IP-Address-or-Public-DNS-Name>/index.php and make sure you can login into the website with myuser user.

![image](https://github.com/genejike/DEVOPS-PROJECT/assets/75420964/2788edda-dbfa-4cb4-933c-c8fe25aaa245)

![image](https://github.com/genejike/DEVOPS-PROJECT/assets/75420964/7add422a-4126-4390-ab38-4d517801f101)






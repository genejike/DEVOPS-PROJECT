# Documentation of Project4

## MEAN STACK DEPLOYMENT TO UBUNTU IN AWS

### self study
MEAN Stack is a combination of the following components:
MongoDB (Document database) – Stores and allows retrieval of data.
Express (Back-end application framework) – Makes requests to Database for Reads and Writes.
Angular (Front-end application framework) – Handles Client and Server Requests
Node.js (JavaScript runtime environment) – Accepts requests and displays results to end user
Refresh your knowledge of OSI model
Read about Load Balancing, and get yourself familiar with different types and techniques of traffic load balancing.
Practice in editing simple web forms with HTML + CSS + JS


### Step 1 – AWS setup
In order to complete this project you will need an AWS account and a virtual server with Ubuntu Server OS.
sign in to AWS free tier account and create a new EC2 Instance of t2.nano family with an Ubuntu Server 20.04 LTS (HVM) image. Remember, you can have multiple EC2 instances, but make sure you STOP the ones you are not working with at the moment to save available free hours.

Hint:you can open your CLI straight from Web Console in AWS, or connect from a terminal or ssh using windows

![Alt text](images/Aws%20setup.png)
connect to your ubuntu machine from your terminal or Aws CLI

![Alt text](images/awssetup2.png)

### Step 1: Install NodeJs
Node.js is a JavaScript runtime built on Chrome’s V8 JavaScript engine. Node.js is used to set up the Express routes and AngularJS controllers here.
Update Ubuntu

![Alt text](images/ubuntu%20update.png)

`sudo apt update`

Upgrade ubuntu

![Alt text](images/ubuntu%20upgrade.png)

`sudo apt upgrade`

Add certificates

`sudo apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates`
`curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -`

![Alt text](images/certificate-install.png)

Install NodeJS

`sudo apt-get install -y nodejs`

![Alt text](images/nodejs-install.png)

Note :if your node js is out of date ensure to update to a recent version depending on what your working on.

### Step 3: Install MongoDB
MongoDB stores data in flexible, JSON-like documents. Fields in a database can vary from document to document and data structure can be changed over time. For our example application, we are adding book records to MongoDB that contain book name, isbn number, author, and number of pages.


`sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list`

![Alt text](images/mango-dbinstall.png)



Install MongoDB

`sudo apt install -y mongodb`
![Alt text](images/mango-dbinstall1.png)

Start The server

`sudo service mongodb start`


Verify that the service is up and running


`sudo systemctl status mongodb`

![Alt text](images/mango-status-check.png)

Install npm – Node package manager.

`sudo apt install -y npm`


Install body-parser package
We need ‘body-parser’ package to help us process JSON files passed in requests to the server.

`sudo npm install body-parser`

![Alt text](images/body-parser.png)

Create a folder named ‘Books’

`mkdir Books && cd Books`

In the Books directory, Initialize npm project

`npm init`

![Alt text](images/npm-init.png)
 
Add a file to it named server.js

`vi server.js`

![Alt text](images/vi-server2.png)
![Alt text](images/vi-server.png)

Copy and paste the web server code below into the server.js file.

    var express = require('express');
    var bodyParser = require('body-parser');
    var app = express();
    app.use(express.static(__dirname + '/public'));
    app.use(bodyParser.json());
    require('./apps/routes')(app);
    app.set('port', 3300);
    app.listen(app.get('port'), function() {
    console.log('Server up: http://localhost:' + app.get('port'));
    });


## INSTALL EXPRESS AND SET UP ROUTES TO THE SERVER
### Step 4: Install Express and set up routes to the server

Express is a minimal and flexible Node.js web application framework that provides features for web and mobile applications. We will use Express to pass book information to and from our MongoDB database.
We also will use Mongoose package which provides a straightforward, schema-based solution to model your application data. We will use Mongoose to establish a schema for the database to store data of our book register.

`sudo npm install express mongoose`

In ‘Books’ folder, create a folder named apps

`mkdir apps && cd apps`

![Alt text](images/cd%20books%20apps%20and%20models.png)
Create a file named routes.js

`vi routes.js`

Copy and paste the code below into routes.js

    var Book = require('./models/book');
    module.exports = function(app) {
    app.get('/book', function(req, res) {
    Book.find({}, function(err, result) {
      if ( err ) throw err;
      res.json(result);
    });
    }); 
    app.post('/book', function(req, res) {
    var book = new Book( {
      name:req.body.name,
      isbn:req.body.isbn,
      author:req.body.author,
      pages:req.body.pages
     });
     book.save(function(err, result) {
      if ( err ) throw err;
      res.json( {
        message:"Successfully added book",
        book:result
      });
     });
    });
    app.delete("/book/:isbn", function(req, res) {
    Book.findOneAndRemove(req.query, function(err, result) {
      if ( err ) throw err;
      res.json( {
        message: "Successfully deleted the book",
        book: result
      });
    });
    });
    var path = require('path');
    app.get('*', function(req, res) {
    res.sendfile(path.join(__dirname + '/public', 'index.html'));
    });
    };
In the ‘apps’ folder, create a folder named models

`mkdir models && cd models`

Create a file named book.js

`vi book.js`

Copy and paste the code below into ‘book.js’

    var mongoose = require('mongoose');
    var dbHost = 'mongodb://localhost:27017/test';
    mongoose.connect(dbHost);
    mongoose.connection;
    mongoose.set('debug', true);
    var bookSchema = mongoose.Schema( {
    name: String,
    isbn: {type: String, index: true},
    author: String,
    pages: Number
    });
    var Book = mongoose.model('Book', bookSchema);
    module.exports = mongoose.model('Book', bookSchema);

## Step 5 – Access the routes with AngularJS

AngularJS provides a web framework for creating dynamic views in your web applications. In this tutorial, we use AngularJS to connect our web page with Express and perform actions on our book register.

Change the directory back to ‘Books’

`cd ../..`

Create a folder named public

`mkdir public && cd public`

Add a file named script.js

`vi script.js`
 
Copy and paste the Code below (controller configuration defined) into the script.js file.


    var app = angular.module('myApp', []);
    app.controller('myCtrl', function($scope, $http) {
    $http( {
    method: 'GET',
    url: '/book'
    }).then(function successCallback(response) {
    $scope.books = response.data;
    }, function errorCallback(response) {
    console.log('Error: ' + response);
    });
    $scope.del_book = function(book) {
    $http( {
      method: 'DELETE',
      url: '/book/:isbn',
      params: {'isbn': book.isbn}
    }).then(function successCallback(response) {
      console.log(response);
    }, function errorCallback(response) {
      console.log('Error: ' + response);
    });
    };
    $scope.add_book = function() {
      var body = '{ "name": "' + $scope.Name + 
      '", "isbn": "' + $scope.Isbn +
      '", "author": "' + $scope.Author + 
      '", "pages": "' + $scope.Pages + '" }';
      $http({
       method: 'POST',
       url: '/book',
       data: body
      }).then(function successCallback(response) {
      console.log(response);
      }, function errorCallback(response) {
      console.log('Error: ' + response);
      });
      };
     });

In the public folder, create a file named index.html;

`vi index.html`
 
Copy and paste the code below into index.html file.

     <!doctype html>
     <html ng-app="myApp" ng-controller="myCtrl">
     <head>
      <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.4/angular.min.js"></script>
     <script src="script.js"></script>
     </head>
    <body>
    <div>
      <table>
        <tr>
          <td>Name:</td>
          <td><input type="text" ng-model="Name"></td>
        </tr>
        <tr>
          <td>Isbn:</td>
          <td><input type="text" ng-model="Isbn"></td>
        </tr>
        <tr>
          <td>Author:</td>
          <td><input type="text" ng-model="Author"></td>
        </tr>
        <tr>
          <td>Pages:</td>
          <td><input type="number" ng-model="Pages"></td>
        </tr>
      </table>
      <button ng-click="add_book()">Add</button>
    </div>
    <hr>
    <div>
      <table>
        <tr>
          <th>Name</th>
          <th>Isbn</th>
          <th>Author</th>
          <th>Pages</th>
 
        </tr>
        <tr ng-repeat="book in books">
          <td>{{book.name}}</td>
          <td>{{book.isbn}}</td>
          <td>{{book.author}}</td>
          <td>{{book.pages}}</td>
 
          <td><input type="button" value="Delete" data-ng-click="del_book(book)"></td>
        </tr>
      </table>
    </div>
  </body>
</html>
Change the directory back up to Books

`cd ..`

Start the server by running this command:
`node server.js`

![Alt text](images/nodejs-start.png)

The server is now up and running, we can connect it via port 3300.
 You can launch a separate Putty or SSH console to test what the curl command returns locally.

`curl -s http://localhost:3300`

It shall return an HTML page, it is hardly readable in the CLI, but we can also try and access it from the Internet.
For this – you need to open TCP port 3300 in your AWS Web Console for your EC2 Instance.

![Alt text](images/html-page-return.png)

Your security group shall look like this:

![Alt text](images/addport3300.png)



Now you can access our Book Register web application from the Internet with a browser using a Public IP address or Public DNS name.
A quick reminder on how to get your server’s Public IP and public DNS name:
You can find it in your AWS web console in EC2 details

Run

`curl -s http://169.254.169.254/latest/meta-data/public-ipv4 for Public IP address`

 or 

`curl -s http://169.254.169.254/latest/meta-data/public-hostname` for Public DNS name.

- This will not work anymore due to aws new security policies read on Metadata and IMDV2.This is the new waw to retrieve your Public IP address
```
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` 
curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/public-ipv4

``

This is how your WebBook Register Application will look in the browser:

![Alt text](images/FINAL%20OUTLOOK.png)

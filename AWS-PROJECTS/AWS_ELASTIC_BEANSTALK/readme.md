### SETTING UP AWS ELASTICBEANSTALK
Step 1: Prepare Your Website

* Ensure that your website is a web application or a collection of files (HTML, CSS, JavaScript, etc.) that you want to host. Organize your website files into a directory on your local machine.

* Step 2: Create an Elastic Beanstalk Application

Sign in to the AWS Management Console.
Navigate to the Elastic Beanstalk service.
Click on "Create Application".
Enter a name for your application.
Optionally, describe your application.
Click "Create".
Step 3: Configure Your Environment

After creating the application, click on "Create Environment".
Choose the web server environment type.
Select the platform that matches your application (e.g., Node.js, Python, Ruby, PHP, Java, .NET, etc.).
Choose the appropriate application code deployment method (upload your code or use a version control system like Git).
Click "Create environment".

Step 4: Upload Your Application Code

If you choose to upload your code during environment creation, you'll be prompted to upload your application code.
Upload the ZIP file or individual files containing your website code.
Optional, you can choose to use the S3 bucket if you already have this 

Wait for the application to deploy.
Step 5: Configure Environment Settings (Optional)

Configure environment settings such as instance type, capacity, environment variables, database connection strings, etc., as needed.
You can adjust these settings later from the Elastic Beanstalk console.
Step 6: Access Your Website

Once the environment is created and the application is deployed, you'll see a URL for accessing your website.
Click on the URL to open your website in a web browser and verify that it's working correctly.
You can also assign a custom domain to your Elastic Beanstalk environment if needed.

Step 7: Monitor and Manage Your Environment

Monitor your environment's health, performance, and resource utilization from the Elastic Beanstalk console. Scale your environment up or down as needed to handle changes in traffic or workload. Update your application code or environment configuration as needed.

### NOTE:IF THIS IS YOUR FIRST TIME USING AWSELASTICBEANSTALK 
Ebs usually creates  aws-elasticbeanstalk-ec2-role but due to aws security polices it no longer does this so you will have to create the role in your IAM manually 
if your AWS account doesn’t have an EC2 instance profile, you must create one using the IAM service. You can then assign the EC2 instance profile to the new environments that you create.

Follow this steps to do so:

- Open IAM Console 
- In the navigation pane of the console, choose Roles and then create role
- Under Trusted entity type, choose AWS service 
- Under Use case, choose EC2 
- Choose Next 
- Attach- :
  1. AWSElasticBeanstalkWebTier,
  2. AWSElasticBeanstalkWorkerTier
- Choose Next :Enter a name for the role - aws-elasticbeanstalk-ec2-role 
- Choose Create role.

If you already have an instance profile, make sure you have below-required policies. To meet the default use cases for an environment, these policies must be attached to the role for the EC2 instance profile:-

Role name: aws-elasticbeanstalk-ec2-role

Permission policies attached:-

AWSElasticBeanstalkWebTier
AWSElasticBeanstalkWorkerTier
AWSElasticBeanstalkMulticontainerDocker
```
Trust relationship policy for EC2:-

{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```
![alt text](image.png)
#### source:

[CREATING EC2 INSTANCE PROFILE](https://stackoverflow.com/questions/30790666/error-with-not-existing-instance-profile-while-trying-to-get-a-django-project-ru/76620598#76620598)
[HANDS-ON MENTORSHIP BY CHISOM JUDE](https://github.com/genejike/Hands-on-Devops-Project/blob/master/Project-02/02%20-%20AWS/buildonaws.md)

[elasticbeanstalk implementation on youtube ](https://www.youtube.com/watch?v=3h7PMHnilkM)

[aws documentation](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/GettingStarted.CreateApp.html)
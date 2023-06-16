## Business Case Study: Implementation of CI-CD for Hello World 

Myworks.xyz is a leading commercial bank in Nigeria with a strong reputation for service excellence, alternative delivery channel platform, strong corporate governance, top of the range IT infrastructure, and wide network expansion. The company has a presence in Africa, the UAE, China, USA, and the United Kingdom. The company has about 12,000 users using the Core business system and about 790 branches across the country.

The company has identified an issue around it’s solution delivery process and time-to-market and has commenced the adoption of Agile DevOps to address this issue. You have been hired as an Analyst, DevOps automation and your job include the setting up of CI-CD pipelines for upcoming projects. Details of your immediate task is as below 

1.	Download the code for “Hello World” solution from https://github.com/chunglee-ochieze/HelloWorld
2.	Working on Azure DevOps, create a Git repository and check in the code 
3.	Create and run an Azure Build Pipeline for the solution 
4.	Create an Azure app service for the solution 
5.	Create and run an Azure Release pipeline for the solution
6.	Confirm your deployment by browsing the app service URL


# Task 1

- I downloaded the zip file of the code 
![Alt text](Images/Task1.3.png)


- upziped it and pasted the code into a new folder and opened the folder using Visual Studio Code 
![Alt text](Images/task%201.png)

![Alt text](Images/repo%20sync%202.png)

# Task 2. Working on Azure DevOps, create a Git repository and check in the code 
First thing is to create a project in AzureDevops 
 
 - I named mine `Hello-World

 - I selected agile beacause the company has commenced the adoption of Agile DevOps to address it's solution delivery process and time-to-market
![Alt text](Images/hello%201.png)

- Navigate to repo then to files

- Copy the code under Push an existing repository from command line 

![Alt text](Images/repo%20sync%201.png)

- refresh the webpage and we see the code 
![Alt text](Images/repo%20refresh.png)


# Task 3. Create and run an Azure Build Pipeline for the solution 

- Go to pipeline
![Alt text](Images/add%20sonarcloud.png)
![Alt text](Images/add%20sonarcloud%202.png)
![Alt text](Images/add%20sonarcloud%201.png)

I added Sonar cloud plugin to the organistaion
I then went to https://www.sonarsource.com/products/sonarcloud/ to handle configurations 


SonarCloud performs static code analysis, identifying potential bugs, vulnerabilities, and code smells, allowing you to address them early in the development process. By integrating SonarCloud into your CI/CD pipeline, you can ensure that your code meets industry standards and best practices, ultimately improving the overall quality and security of your software.
- get a PAT token for the sonarcloud intergation 
![Alt text](Images/sonar%20pat.png)
- Intergtrated a service connection with sonarcloud  
![Alt text](Images/service%20connection%20i.png)

![Alt text](Images/service%20connection%20ii.png)

![Alt text](Images/service%20connection%20iii.png)

- Let's build and add sonar cloud to othe agent job

![Alt text](Images/service%20connection%20iv.png)

![Alt text](Images/asp1.png)

![Alt text](Images/service%20connection%20vi.png)

- set the jobs up
![Alt text](Images/build%20pipeline.png)
![Alt text](Images/ran%20sonarcloud%20jobs%20with%20code.png)

![Alt text](Images/build%20sucessful.png)


- using sonacloud to recieve summary report of the above the code technical debts 

![Alt text](Images/sonarcloud%20summary.png)




# Task 4. Create an Azure app service for the solution 

using the auzre portal i created:

- A resource group
- An app service plan

Then i created a Dotnet Webapp
![Alt text](Images/app%20service.png)
![Alt text](Images/app%20service1.png)
![Alt text](Images/app%20service2.png)

![Alt text](Images/appservice%20up%20and%20running.png)

# Task 5 Create and run an Azure Release pipeline for the solution

- Go to release

![Alt text](Images/release%20q.png)

- New pipeline
![Alt text](Images/release%20b.png)

- Select azure app service deployment
![Alt text](Images/release%20c.png)



- Configure Development environment task
![Alt text](Images/release%20d%20for%20dev%20task%20setup.png)

- Add artiact and enable continous intergration trigger
![Alt text](Images/add%20arifact.png)


- Create QA and Production app services
![Alt text](Images/hello%20QA%20appservice.png)
![Alt text](Images/Hello%20Prod.png)

- Upgrade pricing to have access to some feature such as deployment slot 
![Alt text](Images/select%20production%20pricing.png)

- create a staging production environment

![Alt text](Images/PROD%20solt.png)
![Alt text](Images/stagging%20created.png)
![Alt text](Images/stagging%20env.png)


- My Azure devop project and go to release pipeline

- set QA task
![Alt text](Images/QA%20TASK%20SETUP.png)

 
- I enabled pre-deployment approval 
![Alt text](Images/predeployment%20approval%20QA.png)

- Production site before swaping with staging env slot
![Alt text](Images/PROD%20SITE%20doamin.png)
![Alt text](Images/PROD%20SITE.png)


- Setup Production staging environment  
![Alt text](Images/PROD%20solt%203.png)
![Alt text](Images/PROD%20solt%204.png)
![Alt text](Images/successfully%20deployecd%20to%20prod(staging%20env).png)

- We need to swap stagingenv with Production
![Alt text](Images/PROD%20swap%20staging%20site.png)

  - ![Alt text](Images/PROD%20swap%20staging%20to%20Prod%20site.png)

  Select Source and target then swap
  - ![Alt text](Images/PROD%20swap%20staging%20to%20Prod%20site%201.png)
  - ![Alt text](Images/sucessful%20swap.png)


## Our swap was sucessful let's see if it's up nd running in production server 
![Alt text](Images/PROD%20swaped%20to%20prod%20SITE%20doamin.png)



# UP AND RUNNING
![Alt text](Images/up%20and%20running.png)







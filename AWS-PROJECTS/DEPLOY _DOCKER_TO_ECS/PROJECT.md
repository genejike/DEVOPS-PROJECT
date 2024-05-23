## DEPLOY DOCKER CONTAINERS ON ECS FROM YOUR LOCAL REPOSITORY 

1. Build and Ship a docker application
- create your docker files 
2.login to aws and create ecr repositories
- one for frontend and one for backend
3.navaigate to ecs
- create a cluster
- create your task definitions one for frontend and backend
- create tasks in ecs 
4. push your docker images to ecr
- select the ecr repository you ant to push to and click on view push commands
- follow the commands to build and push your images to ecr
  c
5. create a programmatic user that has  full access to ecr and ecs and add on github
6. set up application load balancer and 2 target group one for backend and frontend 
  to route traffic 









Resources
[DOCKER COMPOSE](https://www.docker.com/blog/docker-compose-from-local-to-amazon-ecs/#:~:text=For%20deploying%20a%20Compose%20file,of%20Docker%20Compose%20should%20work.)

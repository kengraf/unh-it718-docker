# UNH-IT718-docker
Course demo for introduction to Docker and the 12-factor-app

The container created in this repo is the input to [Github UNH-IT718-k8s](https://github.com/kengraf/UNH-IT718-k8s)

The sample Golang application provides three functions. No Golang knowledge is required
- /hello  # Echo back the local IP address with a possible random upto 10 sec delay
- /headers   # Display the HTTP headers used
- /dowork # Wastes time by generating millions of random numbers so we can play with Kubernetes scaling

## Where do you run your containers?
For simple FREE experimentation `https://labs.play-with-docker.com/` is hard to beat.
Both GCP and AWS have required account setup which is defined in the NOTES section below.  

[Docker cheat sheet](https://dockerlabs.collabnix.com/docker/cheatsheet/)  
[Kubenetes cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)  

## Experiment with a builder style Docker deployment.  

### The build
```
git clone https://github.com/kengraf/unh-it718-docker.git
cd unh-it718-docker
docker build -t http .
```

Validation: this is a good time to experiment with commands from the Docker cheat sheet.    
Show the 3 images: goland pulled from DockerHub, a unnamed developer image, and the scratch based http image
```
docker images
```
Show additional image layers created during the build
```
docker images --all 
```
No active containers until you run something
```
docker ps -a 
```

Run time  
Build the application, /header returns immediately, /hello within 10 second, /dowork should take a minute or two  

```
docker run -d -p 80:8090 http
curl http://localhost/hello
curl http://localhost/headers
curl http://localhost/dowork
```

***Items for class consideration***  
Why not seperate building the **developer** and **deployer** images into different Dockerfiles?  
Can you retrieve the "app" and run it locally?   
Is the "app" located in the same directory for both the **developer** and **deployer** images?  Can you prove it?  
Can you explain the significant size difference in the images?  
Which image can you debug by getting shell access via: `docker run -it <IMAGE> /bin/sh`?   
Is there any way to debug the "http" container?  
What happens to the images and containers when the cloudshell/playground session temrinates?  

### The deployment cycle
To finish the build CI cycle we need to push our image to Docker Hub, this primes the CD cycle  
You will need a docker hub account http://hub.docker.com.  
My Dockerhub account is *billiardyoda*, you will need to subsitute your Dockerhub handle.  
```
docker login --username billiardyoda
docker tag http billiardyoda/hpa-example:v1
docker push billiardyoda/hpa-example:v1
```
***Extra Credit***  
Why should the deployer trust what the developer pushed?  
How do we validate content?  
How do we assess security?  
How do we understand the impact of upgrading?  

## Build a swarm  
At this point we have a known good container.  So let's use Docker swarm to deploy a higher availability environment.  The commands below show how to build a swarm by hand.  The Docker playground will build the swarn for you automatically.  

### Create the swarm on the initial manager instance
```
docker swarm init
```
#### Create tokens to join the swarm, either as a manager or worker.  
```
docker swarm join-token manager
```
```
docker swarm join-token worker
```
On the additional nodes issue the join command shown as output of the above commands  

### Publish the app to the swarm.  
This create an overlay network that offers port 8090 to the outside world  
```
docker service create --name http --replicas 3 --publish published=8090,target=8090 billiardyoda/hpa-example:v1
```

## NOTES
#### GCP Setup
It's assumed you are running in GCP Cloudshell as it provides builtin Go, Docker, and Kubernetes support.  
Your cloudshell should be associated with a fully authorized project and located in your preferred region.  
The following commands are provided for your conveniance.
```
PROJECT_ID=???
```
```
gcloud projects create $PROJECT_ID
gcloud config set project $PROJECT_ID
gcloud services list --available
gcloud services enable container.googleapis.com
gcloud config set compute/zone us-west1-a
```

## Need to clean up Docker to release GCP resources
```
docker rm -vf $(docker ps -aq)  
docker rmi -f $(docker images -aq)
```
#### AWS Setup
TBD


# UNH-IT718-docker
Course demo for 12-factor and Docker

The output of this process is the input to [Github UNH-IT718-k8s](https://github.com/kengraf/UNH-IT718-k8s)

The sample Golang application provides three functions. No Golang knowledge is required
- /hello  # Echo back hello with a possible random upto 10 sec delay
- /headers   # Display the HTTP headers used
- /dowork # Wastes time by generating millions of random numbers so we can play with Kubernetes scaling

## Setup
It's assumed you are running in GCP Cloudshell as it provides builtin Go, Docker, and Kubernetes support.  
Your cloudshell should be associated with a fully authorized project and located in your preferred region.  
The following commands are provided for your conveniance.
```
gcloud projects create YOUR_PROJECT_ID
gcloud config set project YOUR_PROJECT_ID
gcloud services list --available
gcloud services enable container.googleapis.com
gcloud config set compute/zone us-west1-a
```
[Docker cheat sheet](https://dockerlabs.collabnix.com/docker/cheatsheet/)  
[Kubenetes cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)  

## Lesson #1
Review Docker Lab's Github: [12 Factor Application](https://github.com/docker/labs/tree/master/12factor)

***Extra Credit***
Does Docker help drive all 12 factors?
Which factor is Docker most/less helpful?

## Lesson #2
Experiment with a builder style Docker deployment.  

The build
```
git clone https://github.com/kengraf/12-factor-app.git
cd 12-factor-app
docker build -t http .
```

Validation: this is a good time to experiment with commands from the Docker cheat sheet.  
```
docker images # 3 images: goland pulled from DockerHub, a unnamed developer image, and the scratch based http image
docker images --all # show additional image layers created during the build
docker ps -a # No containers until you run something
```

Run
```
# The built application, /hello and /header return immediately, /dowork should take a minute or two
docker run -d -p 80:8090 http
curl http://localhost/hello
curl http://localhost/headers
curl http://localhost/dowork
```
***Extra Credit***  
Why not seperate building the **developer** and **deployer** images into different Dockerfiles?
Can you retrieve the "app" and run it locally?  
Is the "app" located in the same directory for both the **developer** and **deployer** images?  Can you prove it?  
Can you explain the significant size difference in the images?  
Which image can you debug by getting shell access? docker run -it IMAGE SHELL  
Is there any way to debug the "http" container?  
What happens to the images and containers when the cloudshell session temrinates?  

To finish the build CI cycle we need to push our image to Docker Hub, this primes the CD cycle
You will need a docker hub account http://hub.docker.com.  
```
docker login --username YOUR_NAME
docker tag http YOUR_NAME/hpa-example:v1
docker push YOUR_NAME/hpa-example:v1
```
***Extra Credit***  
Why should the deployer trust what the developer pushed?
How do we validate content?
How do we assess security?
How do we understand the impact of upgrading?

## Clean up Docker
```
docker rm -vf $(docker ps -aq)  
docker rmi -f $(docker images -aq)
```


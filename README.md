# 12-factor-app
Course demo for 12-factor, Docker, K8s concepts

## Setup
It's assumed you are running in GCP Cloudshell as it provides builtin Go, Docker, and Kubernetes support.  
Your cloudshell should be associated with a fully authorized project.  The following command provided for your conveniance.
```
tbd
```
[Docker cheat sheet](https://dockerlabs.collabnix.com/docker/cheatsheet/)  
[Kubenetes cheat sheet]()  

## Lesson #1
Review Docker's blog on 12 Factor deployment
```
tbd
```

## Lesson #2
Experiment with various Docker deployments.  
This lesson following most of the steps detailed in [Alex Ellis' blog Multi-stage Docker builds](https://blog.alexellis.io/mutli-stage-docker-builds/).  
The original, and more complex, source in [Alex Ellis' Github repo](https://github.com/alexellis/href-counter)  


```
git clone https://github.com/kengraf/12-factor-app.git
cd href-counter
docker build -t href-counter .
docker run -e url=https://google.com/ href-counter
```

Validate the Docker build.  This is a good time experiment with commands from the Docker cheat sheet.  
```
docker images # 4 images: apline & goland pulled from DockerHub, a named **developer** image, and href-counter
docker iamges --all # show additional image layers created during the build
docker ps -a # No containers until you run something

# Run the build application, checking the hrefs on Github
docker run -e url=https://github.com/ href-counter
docker ps -a # A containers for each run command
```
_**Extra Credit**_
Can you retrieve the "app" and run it locally?
Is the "app" located in the same directory for both the **developer** and **deployer** images?  Can you prove it?

## Clean up
```
docker rm -vf $(docker ps -aq  
docker rmi -f $(docker images -aq)
```

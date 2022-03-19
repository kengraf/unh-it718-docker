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
git clone https://github.com/alexellis/href-counter.git
cd href-counter
docker build -t href-counter . -f Dockerfile.multi
docker run -e url=https://www.alexellis.io/ href-counter
```

# jenkins agent for devops on aws

## links

dockerhub: https://hub.docker.com/r/expire163/jenkins-docker-slave

pull: `docker pull expire163/jenkins-docker-slave`

## what

Based on an ssh version of an old jenkins agent from beginning of docker, a new agent is now there.

**Jenkins Agent premade for devops**

## why

sick of calling `docker run node /bin/npm build` all over the pipelines

## whats inside

- openssh-server (for connecting to it)
- git
- terraform
- TFLint
- helm 3
- kubectl
- aws-cli
- aws-iam-authenticator
- amazon-ecr-credential-helper-releases
- *java 8 for jenkins counter part - might change*


## prod ready?

no - not quite!
still requires better login options then user=password :grin:

![alt text](https://github.com/hoabka/immutable-infra/blob/main/res/vm-based-flow.JPG)
## Objectives
- In this example, I'm using immutable infra flow pattern with **Packer**, **Terraform**, **Ansible** and **Jenkins** to build simple webapp application (nginx + simple tomcat webapp).

- What will you learn from this example
-- How to use **Jenkinfile**, Docker-based Jenkin Agents
-- How to use Infrastructure as Code tool like **Terraform** and **Packer**
-- How to use Config Management tool like **Ansible** with config rendered from **Terraform**

## 1. Prequisites

### 1.1. Install Jenkins + Docker
-- Install [Jenkins](https://www.jenkins.io/doc/book/installing/linux/), [Docker](https://docs.docker.com/engine/install/ubuntu/)

### 1.2. Setup AWS credentials on Jenkins
- To work with AWS, we need to have credential information.
- To be simple, I use ACCESS  and SECRET KEY (equivalent to **PACKER_AWS_ACCESS_KEY** and **PACKER_AWS_SECRET_KEY**) 

## 2. How to deploy
### 2.1. Packaging images with Packer
- Create  **Packing-Image** job
![alt text](https://github.com/hoabka/immutable-infra/blob/main/res/packaging-image.JPG)
- Run packaging image job to build AMI

### 2.2. Infra Deployment
- Create  **Infra-deployment** job
![alt text](https://github.com/hoabka/immutable-infra/blob/main/res/infra-deployment.JPG)
- Run **Infra-deployment** job to provision infra and deploy application

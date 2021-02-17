  
![alt text](https://github.com/hoabka/immutable-infra/blob/master/res/container-based-flow.JPG "CI/CD workflow")    
    
## Objectives    
 In this example, I'm using immutable infra flow pattern with **Spinnaker**, **EKS** and **Jenkins** to build simple webapp application (simple tomcat webapp).    
    
 What will you learn from this example    
- How to use **Jenkinfile**
- How to use Infrastructure as Code tool like **Terraform** and build EKS cluster with autoscaling 
-  How to use CD platform tool like **Spinnaker** work with **Kubernetes**    
 ## Introduction 
 - This example includes 4 main tasks: 
- **Bootstraping EKS cluster**: By using terraform to bootstrap autoscaling EKS cluster
- **Setup Jenkin pipeline** for building Docker image
- **Install/Setup Spinnaker** for CD platform and work with EKS-based Kubernetes 
- **Deploy simple java webapp** using spinnaker pipeline and Kubernetes
    
## 1. Prequisites - Software version information    
    
| Software| Version  |    
|--|--|    
| OS |Ubuntu 18.04  |    
| Spinnaker |1.20.2  |    
| Kubernetes |1.18.0  |    
| Terraform | 0.12.24  |    
### 1.1. Provision EKS cluster - Using your workspace with terraform, [kubectl](https://kubernetes.io/vi/docs/tasks/tools/install-kubectl/), [halyard](https://spinnaker.io/setup/install/halyard/) installed    
- Setup needed variables for terraform   
- Provisioning infra     
```console $ cd container-based/terraform  
$ terraform apply --auto-approve  
```
 **NOTE**: Take note EKS cluster name (ex: **demo-eks-cluster**) and ECR URL from output of terraform apply. I will use **demo-eks-cluster** as my EKS cluster name in this guideline  
### 1.2. Create Spinnaker Service Account to work with EKS   
```console 
$ cd demo-eks-cluster 
$ bash update-kubeconfig.sh  
``` 
### 1.3. Bootstrap Spinnaker   
```console 
$ export KUBECONFIG=./config-demo-eks-cluster 
```  
- Setup Spinnaker using [Halyard](https://spinnaker.io/setup/install/)  
### 1.4. Setup Kubernetes provider  
- [Guideline](https://spinnaker.io/setup/install/providers/kubernetes-v2/)  
### 1.5. Setup Jenkins  
- [Guideline](https://spinnaker.io/setup/ci/jenkins/)  
### 1.6. Setup Github artifact account  
- To allow Spinnaker listen with changes on Github, we need to add a Github artifact account  
- [Guideline](https://spinnaker.io/setup/artifacts/github/)  
## 2. Setup Spinnaker pipeline  
### 2.1. Setup Jenkins job 
- Create  **spinnaker-demo** job    
    
![alt text](https://github.com/hoabka/immutable-infra/blob/master/res/spinnaker-demo-jenkin-job.JPG "spinnaker-demo jenkin job")    
    
    
### 2.2. Create Spinnaker Application and Pipeline  
- Create  **Application**   
 ![alt text](https://github.com/hoabka/immutable-infra/blob/master/res/spinnaker-application.JPG "Spinnaker Application")    
    
- Create Pipelines  
  1. Deployment pipeline  
![alt text](https://github.com/hoabka/immutable-infra/blob/master/res/spinnaker-deployment-pipeline.JPG "Spinnaker Deployment pipeline")    
   - Choose **Edit as JSON** and copy/paste content from [spinnaker/deployment_pipeline.json](https://github.com/hoabka/immutable-infra/blob/master/container-based/spinnaker/deployment_pipeline.json)
   
  2. Service pipeline  
   ![alt text](https://github.com/hoabka/immutable-infra/blob/master/res/spinnaker-service-pipeline.JPG "Spinnaker Service Pipeline")  
  - Choose **Edit as JSON** and copy/paste content from [spinnaker/service_pipeline.json](https://github.com/hoabka/immutable-infra/blob/master/container-based/spinnaker/service_pipeline.json)

## 3. Deployment  
- Click on **Start Mannual Execution** button on the deployment pipeline to deploy **samplewebapp** application  
- Do the same with the service pipeline to expose a service with LoadBalancer type for **samplewebapp** application  
  
## 4. Verify deployment 
- Get **External LB** from **kubectl**
 ```console 
$ kubectl get svc -l "app=samplewebapp" \
 -o jsonpath="{.status.loadBalancer.ingress[*].hostname}"
```    
    
- Visit to **lb_dns**, it should show the **SampleWebApp** page    
    
![alt text](https://github.com/hoabka/immutable-infra/blob/master/res/sample-webapp-page.JPG "Sample  Java WebApp")    
    
    
## 4. Cleanup 
- Run terrform destroy command  
```console
$ terraform destroy --auto-approve
```
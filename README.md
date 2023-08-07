# Deploy Flask-MySQL App on AWS EKS Using Jenkins - Sprints Capstone Project

## Description

This project aims to deploy a Python Flask web application with MySQL as the database on AWS Elastic Kubernetes Service (EKS) with Nginx Ingress Controller. 
The Continuous Integration and Continuous Deployment (CICD) automation process is achieved using Jenkins running on an AWS instance. 
The AWS infrastructure is provisioned using Terraform, and configuration management is handled with Ansible.                   

------------------------------------------------
## Project Overview

![0deaae45-6b28-49b4-a3a8-34017ddacaf4](https://github.com/eslamkhaled560/deploy-app-eks-jenkins-terraform-ansible/assets/54172897/3eb42f72-ae2e-4e49-9f80-52d011c18254)

------------------------------------------------
## Prerequisites

- Terraform
- Ansible
- GIT
- Github User and Access Token
- AWS CLI
- AWS Programmatic User Credentials with Admin Permissions

------------------------------------------------
## Step by Step Walkthrough

### IaC Automation

- Clone repository:
```
git clone https://github.com/eslamkhaled560/deploy-app-eks-jenkins-terraform-ansible.git
```

- Customize Terraform and Ansible variables by replacing them with your preferred values.            
  Terraform Values File: [IaaC/values.auto.tfvars](https://github.com/eslamkhaled560/deploy-app-eks-jenkins-terraform-ansible/blob/main/IaaC/values.auto.tfvars)         
  Ansible Values File: [IaaC/roles/jenkins/vars/main.yml](https://github.com/eslamkhaled560/deploy-app-eks-jenkins-terraform-ansible/blob/main/IaaC/roles/jenkins/vars/main.yml)

- Personalize the ```inventory.txt``` file by setting the appropriate user and private key path.
  Inventory File: [IaaC/inventory.txt](https://github.com/eslamkhaled560/deploy-app-eks-jenkins-terraform-ansible/blob/main/IaaC/inventory.txt)

- The [IaaC/iaac-automation.sh](https://github.com/eslamkhaled560/deploy-app-eks-jenkins-terraform-ansible/blob/main/IaaC/iaac-automation.sh) script orchestrates the entire AWS infrastructure setup and Jenkins instance configuration processes without requiring any manual intervention.
```
cd deploy-app-eks-jenkins-terraform-ansible/IaaC
sudo chmod 400 iaac-automation.sh
./iaac-automation.sh                                  
```

- It will take from 20 to 30 minutes to get ready.

------------------------------------------------
### Jenkins Configuration:

Once the infrastructure is ready, the automation script will generate two files:
- __IaaC/jenkins-pub-ip.txt__ : Jenkins' public IP address.               
- __initialAdminPassword__: Initial admin password for Jenkins' first login.         
To access Jenkins, use the provided public IP address on port 8080 and log in using the initial password.
```
jenkins-public-ip:8080                              # on any web browser
```

- Install suggested plugins (no specific plugins needed), then log in.

Go to ```Manage Jenkins > Credentials``` and add the following credentials:
- __github:__ user and password (github access token)
- __aws_access_key_id:__ Secret text
- __aws_secret_access_key:__ Secret text
- __ecr:__ User name and Password (get the password from the terminal ```aws ecr get-login-password --region ${REGION}```)         
>  You can utilize your personalized IDs, but please remember to update them in the Jenkinsfile accordingly.           

![13- jenkins-credentials](https://github.com/eslamkhaled560/deploy-app-eks-jenkins-terraform-ansible/assets/54172897/63435989-e6c4-4317-8509-71c7d417b76d)

------------------------------------------------
### Jenkins Pipeline & Webhhook

- Create a pipeline by connecting your GitHub repository and enabling the webhook option.
  
![15- pipeline-webhook](https://github.com/eslamkhaled560/deploy-app-eks-jenkins-terraform-ansible/assets/54172897/bbd7a8ae-5d92-4908-9293-5a9e1e40eea5)

![16- pipeline-github](https://github.com/eslamkhaled560/deploy-app-eks-jenkins-terraform-ansible/assets/54172897/3454156e-1289-4f4a-abb3-bf5e30576be8)

- Set up a webhook on GitHub by navigating to your repository's settings, selecting Webhooks, and adding a new webhook with the provided URL
```
http://jenkins-public-ip:8080/github-webhook/
```

![12- webhook](https://github.com/eslamkhaled560/deploy-app-eks-jenkins-terraform-ansible/assets/54172897/5c46516f-6667-4a12-9251-bae1692b6beb)

- Ensure that all environment variables and credential names in the Jenkinsfile are personalized with your specific values.                               
File Related: [Jenkinsfile](https://github.com/eslamkhaled560/deploy-app-eks-jenkins-terraform-ansible/blob/main/Jenkinsfile)

------------------------------------------------
### Build Pipeline & View Output

- Build Pipeline (It can be built automatically upon any push)
  
![17- build](https://github.com/eslamkhaled560/deploy-app-eks-jenkins-terraform-ansible/assets/54172897/bb8d9b43-172a-4396-ab67-768b4a6158fc)

- View the console output and access the application URL.
  
![18- console-output-url](https://github.com/eslamkhaled560/deploy-app-eks-jenkins-terraform-ansible/assets/54172897/4e8c032c-6dd7-4196-be8e-de9aeb649b97)

- Signing up will not display any page, but you can still log in and add your wishes.

![19- add-wish](https://github.com/eslamkhaled560/deploy-app-eks-jenkins-terraform-ansible/assets/54172897/c24babad-de81-4696-9964-dec6a7307a20)

------------------------------------------------
## Clean Up Resources

- Delete the ERC images on AWS, as Terraform won't be able to destroy them if the repository is not empty.

- Delete Kubernetes resources, as Terraform will struggle to delete some resources that depend on the Nginx Ingress LoadBalancer.
```
aws eks update-kubeconfig --name ${CLUSTER_NAME}
kubectl delete -f path-to-cloned-repo/k8s
```

- Destroy all AWS resourses
```
cd path-to-cloned-repo/IaaC
terraform destroy                              # you need to type 'yes' when prompt or use '--auto-approve' flag
```

------------------------------------------------

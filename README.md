The goal of this project is to create secure infrastructure for a website on AWS cloud.
Using project's source code you can provision mentioned infrastructure using Terraform and then deploy a website using Ansible and Docker.

Here are main elements of the project infrastructure:

* Two public subnets that contain:
    - an Internet Gateway
    - 2 NAT Gateways (1 per each public subnet)
    - an Application Load Balancer
    - a Bastion server to access webservers in private networks via SSH


* Two private subnets that contain:
    - 2 webservers located in 2 private subnets
    - one RDS instance with MariaDB database
    - (optional) Read replica for the database (corresponding code is fully functioning, however it is commented because creation of a read replica takes additional 30 minutes)

Access to the webservers and the RDS instance is controlled using Security Groups.

## **Prerequisites**

In order to start this project you will need:
- [AWS account](https://aws.amazon.com/free/)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) - to configure access to AWS cloud
- [Terraform](https://developer.hashicorp.com/terraform/downloads) - to provision infrastructure on AWS cloud
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html) - to configure servers and deploy a website

Steps to start the project:

1. In AWS [create an IAM user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html) that has programmatic access to such AWS services: EC2, RDS, S3, VPC, SSM, KMS.


2. [Generate Access Key](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) for the created user.


3. Use Access Key and Secret Access Key obtained during previous step to configure AWS CLI. 
   Run following command and enter access keys and choose default AWS region:

    `aws configure --profile <any profile name>`


4. Clone this Git repository to your computer.


5. Create S3 bucket where Terraform will be storing its state. 
   Please use a Terraform file `main.tf` provided in the directory `terraform/state`
    
   Run the following commands:
   
    `cd terraform/state` - to open directory with script
   
    `terraform plan` - to generate list of resources that Terraform will create on AWS cloud. Please, review it carefully before accepting and starting infrastructure provisioning.
    
    `terraform aplly` - to start provisioning of S3 bucket for the project. Please review provisioning plan once again and enter `yes`.
    
Finally, after finishing above mentioned preliminary steps we are ready to continue with the project.

## **Provisioning of the infrastructure**

6. Provided public SSH key will be automatically added to the servers as part of Cloud-Init, so you will be able to access the servers.
Please feel free to generate additional [SSH key pairs](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html) for the servers if needed.
   Afterwards, you can save public part of the SSH key in SSM Parameter Store. Then please add the name of the SSM parameter to the list `admin_public_ssh_keys` in the file `variables.tf`.
   Those keys will be automatically added to servers during provisioning.


7. Change directory to `terraform` by running `cd ..`

   
8. Create text file `secrets.auto.tfvars` in directory `terraform`.
Copy the text below into the `secrets.auto.tfvars` file to assign values to these variables:
   
database_name     = "< a name for the database >"        
   database_username = "< a name for a database user >"               
   database_password = "< a strong password >"
   
Alternatively you can set environment variables in the console by entering:

`export TF_database_name=exampledatabase`

`export TF_database_username=exampleduser`

`export TF_database_password=examplepassword`
    
9. Run `terraform plan` - to generate list of the project resources that Terraform will create on AWS cloud. Please, review it carefully before accepting and starting infrastructure provisioning.


10. Run `terraform aplly` - to start provisioning of the infrastructure. Please review provisioning plan once again and enter `yes`.

Provisioning will take approximately 10 minutes. During provisioning an inventory file for Ansible will be automatically populated with IP-addresses of webservers and a bastion server.
Also, SSM parameters will be created on the AWS to store database endpoint and credentials.
After provisioning is done you will see the output information with the link to the application load balancer, as well as IP-addresses of webservers(private) and the bastion server(public).

## **Configuring the webservers**

11. Switch to `ansible` directory and run `ansible-playbook install_docker.yml`

This command should install Docker on two webservers.

## **Deployment of Wordpress**

12. To deploy Wordpress on webservers run `ansible-playbook deploy_wordpress.yml`
The `compose.yml` file in `docker-compose` folder was changed to disable some Docker capabilities to improve security. 
    Please open loadbalancer URL (obtained as output at step 10) in a browser to see the results of deploy.
    
In order to make this infrastructure production-ready we will need to take additional measures such as:

- add container orchestration
- change ec2 instance type to a larger, compute optimized type
- create autoscaling groups for webservers
- configure logging
- configure monitoring
- configure database read-replicas and standbys
- configure firewalls, etc
- configure backups

## **To delete provisioned infrastructure:**

Change directory to `terraform`
and run `terraform destroy` and confirm actions.
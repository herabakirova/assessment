Prerequisites:
AWS account with necessary IAM permission
terraform 

1. Create S3 bucket and upload dataset file to S3 (your IAM user has to have S3 bucket permission)
2. Create secrets with AWS creds and Docker creds to access repository in ECR.
3. Clone git repository to your machine.
4. Run terraform apply and create Jenkins EC2 inctance with security group (edit: add variables and dynamic ingress)
5. Connect to EC2, ssh-keygen, sudo cat password (edit: try to add "jenkins ALL=(ALL) NOPASSWD:ALL" to sudoers in userdata)
6. Log into Jenkins and create pipeline. Pull Jenkinsfile from git repo and add webhook.
7. Run pipeline (output K8 service endpoint)
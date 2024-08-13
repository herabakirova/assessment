pipeline {
    agent any
    parameters {
        choice(
            name: 'TERRAFORM_ACTION',
            choices: ['apply', 'destroy', 'plan'],
            description: 'Choose the Terraform action to perform'
        )
    }
    stages {
        stage("Checkout SCM") {
            steps {
                git branch: 'test', url: 'https://github.com/herabakirova/assessment.git'
            }
        }
    stage("Terraform init and apply/destroy") {
        steps {
            withCredentials([
                usernamePassword(credentialsId: 'aws', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')
            ]) {
                script {
                    if (params.TERRAFORM_ACTION == 'apply') {
                        sh '''
                        cd aws-infrastructure/
                        terraform init
                        sh 'terraform apply -auto-approve
                        '''
                    } else if (params.TERRAFORM_ACTION == 'destroy') {
                        sh '''
                        cd aws-infrastructure/
                        terraform init
                        terraform destroy -auto-approve
                        '''
                    }   else if (params.TERRAFORM_ACTION == 'plan') {
                        sh '''
                        cd aws-infrastructure/
                        terraform init
                        terraform plan 
                        '''
                    }
                }
            }
        }
    }
        stage('Build and Push Docker Image to ECR') {
            when {
                expression { return params.TERRAFORM_ACTION == 'apply' }
            }
            steps {
                withCredentials([
                    usernamePassword(credentialsId: 'aws', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')
                    ]) {
            sh '''
            aws eks update-kubeconfig --name mycluster
            cd ./application-image
            docker buildx build --platform linux/amd64 -t herabakirova/app:6.0 .
            aws ecr get-login-password --region us-east-2 | sudo -u jenkins docker login --username AWS --password-stdin 588328284151.dkr.ecr.us-east-2.amazonaws.com
            docker tag herabakirova/app:6.0 588328284151.dkr.ecr.us-east-2.amazonaws.com/my-repository:1.0
            docker push 588328284151.dkr.ecr.us-east-2.amazonaws.com/my-repository:1.0
            '''
        }
         }
        }
    stage('Create K8 secrets') {
            when {
                expression { return params.TERRAFORM_ACTION == 'apply' }
            }
          steps {
          withCredentials([
              usernamePassword(credentialsId: 'aws', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')
              ]) {
              sh '''
              kubectl create secret docker-registry ecr-registry-secret \
                  --docker-server=588328284151.dkr.ecr.us-east-2.amazonaws.com \
                  --docker-username=AWS \
                  --docker-password=$(aws ecr get-login-password --region us-east-2)

              kubectl create secret generic aws-credentials \
                  --from-literal=aws_access_key_id=$(aws secretsmanager get-secret-value --secret-id my-aws-creds --query 'SecretString' --output text | jq -r '.aws_access_key_id') \
                  --from-literal=aws_secret_access_key=$(aws secretsmanager get-secret-value --secret-id my-aws-creds --query 'SecretString' --output text | jq -r '.aws_secret_access_key')
              '''
          }
      }
    }
        stage('Package and Install Helm Chart') {
            steps {
            when {
                expression { return params.TERRAFORM_ACTION == 'apply' }
            }
                withCredentials([
                    usernamePassword(credentialsId: 'aws', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')
                    ]) {
                sh '''
                helm package ./food-truck-application
                helm install food-truck-application ./food-truck-application-*.tgz
                kubectl get service
                '''
            }
        }
    }
}
}





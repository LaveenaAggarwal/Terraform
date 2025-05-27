pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-2'
        AWS_ACCESS_KEY_ID     = credentials('your-aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('your-aws-secret-access-key')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }
        stage('Terraform Apply') {
            steps {
                sh 'terraform apply'
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}

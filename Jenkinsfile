pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION     = 'us-east-2'
        AWS_ACCESS_KEY_ID      = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY  = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Checkout') {
            steps {
                cleanWs()
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
                sh 'terraform apply -auto-approve'
            }
        }
    }
}

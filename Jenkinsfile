pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-2'
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        // Add terraform folder to PATH if needed, e.g.:
        // PATH = "${env.PATH};C:\\terraform"
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
                // Print output and fail on error
                script {
                    def output = sh(script: 'terraform init', returnStdout: true).trim()
                    echo output
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                script {
                    def output = sh(script: 'terraform plan', returnStdout: true).trim()
                    echo output
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                script {
                    def output = sh(script: 'terraform apply -auto-approve', returnStdout: true).trim()
                    echo output
                }
            }
        }
    }
}

pipeline {
  agent any

  stages {
    stage('Terraform Init') {
      steps {
        sh '''
          export PATH=$PATH:/c/Users/Laveena/Downloads/terraform_1.12.0_windows_amd64
          terraform init
        '''
      }
    }

    stage('Terraform Plan') {
      steps {
        sh '''
          export PATH=$PATH:/c/Users/Laveena/Downloads/terraform_1.12.0_windows_amd64
          terraform plan
        '''
      }
    }

    stage('Terraform Apply') {
      steps {
        sh '''
          export PATH=$PATH:/c/Users/Laveena/Downloads/terraform_1.12.0_windows_amd64
          terraform apply -auto-approve
        '''
      }
    }
  }
}

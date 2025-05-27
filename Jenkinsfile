pipeline {
  agent any
  stages {
    stage('Terraform Init') {
      steps {
        sh '''
          "/c/Users/Laveena/Downloads/terraform_1.12.0_windows_amd64/terraform.exe" init
        '''
      }
    }
    stage('Terraform Plan') {
      steps {
        sh '''
          "/c/Users/Laveena/Downloads/terraform_1.12.0_windows_amd64/terraform.exe" plan
        '''
      }
    }
    stage('Terraform Apply') {
      steps {
        sh '''
          "/c/Users/Laveena/Downloads/terraform_1.12.0_windows_amd64/terraform.exe" apply -auto-approve
        '''
      }
    }
  }
}

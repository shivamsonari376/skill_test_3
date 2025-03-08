pipeline {
    agent any
    
    environment {
        AWS_ACCESS_KEY_ID = credentials('f2d1f8c6-18f6-4ff1-a19d-ca2d82f6b590')
        AWS_SECRET_ACCESS_KEY = credentials('324bdfd8-b291-4dcc-b3e2-2922468c5b39')
        TF_VAR_region = 'us-east-1' // Specify your desired region
    }
    
    stages {
        stage('Clone Repository') {
            steps {
                script {
                    // Clone the GitHub repository
                    git 'https://github.com/shivamsonari376/skill_test_3.git'
                }
            }
        }
        
        stage('Setup AWS Credentials') {
            steps {
                script {
                    // Configure AWS CLI with credentials
                    sh '''
                        aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                        aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                        aws configure set region $TF_VAR_region
                    '''
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    // Go into the terraform directory and initialize Terraform
                    dir('terraform') {
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    // Apply Terraform configurations
                    dir('terraform') {
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Terraform has been successfully applied.'
        }
        failure {
            echo 'Something went wrong, Terraform did not apply successfully.'
        }
    }
}

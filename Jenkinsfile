pipeline {
    agent any
    environment {
        AZURE_CREDENTIALS = credentials('azure-sp-credentials') 
    }
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }
        stage('Terraform Init') {
            steps {
                script {
                    dir('infra') {
                        sh 'terraform init'
                    }
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                script {
                    dir('infra') {
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                script {
                    dir('infra') {
                        sh 'terraform apply -auto-approve tfplan'
                    }
                }
            }
        }
        stage('Save kube_config') {
            steps {
                script {
                    dir('infra') {
                        sh 'terraform output -raw kube_config > kube_config'
                    }
                    archiveArtifacts artifacts: 'infra/kube_config', fingerprint: true
                }
            }
        }
    }
    post {
        always {
            cleanWs() 
        }
    }
}

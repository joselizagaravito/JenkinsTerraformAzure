pipeline {
    agent any
    environment {
        AZURE_CLIENT_ID       = credentials('AZURE_CLIENT_ID')
        AZURE_CLIENT_SECRET   = credentials('AZURE_CLIENT_SECRET')
        AZURE_TENANT_ID       = credentials('AZURE_TENANT_ID')
        AZURE_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
    }
    stages {
        stage('Login to Azure') {
            steps {
                sh '''
                az login --service-principal \
                    -u $AZURE_CLIENT_ID \
                    -p $AZURE_CLIENT_SECRET \
                    --tenant $AZURE_TENANT_ID
                az account set --subscription $AZURE_SUBSCRIPTION_ID
                '''
            }
        }
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

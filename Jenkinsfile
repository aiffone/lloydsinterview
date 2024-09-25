pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/aiffone/lloydsinterview.git', credentialsId: 'github-pat'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    sh 'docker build -t gcr.io/YOUR_PROJECT_ID/hello-world:latest .'
                }
            }
        }
        stage('Push Docker Image to GCR') {
            steps {
                script {
                    echo 'Authenticating with Google Cloud...'
                    withCredentials([file(credentialsId: 'gcr-service-account', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                        sh 'gcloud auth configure-docker --quiet'
                    }
                    
                    echo 'Pushing Docker image to GCR...'
                    sh 'docker push gcr.io/YOUR_PROJECT_ID/hello-world:latest'
                }
            }
        }
        stage('Deploy with Helm') {
            steps {
                script {
                    echo 'Deploying with Helm...'
                    // Your Helm deployment logic here
                }
            }
        }
    }
}

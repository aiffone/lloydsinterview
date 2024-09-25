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
                    // Building the Docker image with the new Artifact Registry repository URL
                    sh 'docker build -t europe-west1-docker.pkg.dev/infra1-430721/hello/hello-world:latest .'
                }
            }
        }
        stage('Push Docker Image to Artifact Registry') {
            steps {
                script {
                    echo 'Authenticating with Google Cloud...'
                    withCredentials([file(credentialsId: 'gcr-service-account', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                        sh 'gcloud auth configure-docker europe-west1-docker.pkg.dev --quiet'
                    }
                    
                    echo 'Pushing Docker image to Artifact Registry...'
                    // Pushing the Docker image to Artifact Registry in europe-west1
                    sh 'docker push europe-west1-docker.pkg.dev/infra1-430721/hello/hello-world:latest'
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

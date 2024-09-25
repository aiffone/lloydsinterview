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
                    sh 'docker build -t hello-world:nanoserver-ltsc2022 .'
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    echo 'Pushing Docker image...'
                    // Using credentials for Docker login
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh 'echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin'
                        sh 'docker push hello-world:nanoserver-ltsc2022'
                    }
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

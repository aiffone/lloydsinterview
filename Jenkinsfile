pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'hello-world:nanoserver-ltsc2022' // Replace with your Docker repo
        KUBECONFIG_CREDENTIALS_ID = 'micro' // Replace with your Kubernetes config credentials ID
        HELM_RELEASE_NAME = 'lloydsinterview-release' // Replace with your Helm release name
        HELM_NAMESPACE = 'default' // Change if deploying to a specific namespace
    }

    stages {
        stage('Checkout') {
            steps {
                // Check out the code from GitHub
                git url: 'https://github.com/aiffone/lloydsinterview.git', credentialsId: 'github-pat'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    echo 'Building Docker image...'
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    // Log in to Docker and push the image
                    echo 'Pushing Docker image...'
                    sh '''
                        docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
                        docker push $DOCKER_IMAGE
                    '''
                }
            }
        }
        stage('Deploy with Helm') {
            steps {
                script {
                    echo 'Deploying to Kubernetes with Helm...'
                    // Set Kubeconfig for kubectl
                    withCredentials([file(credentialsId: KUBECONFIG_CREDENTIALS_ID, variable: 'KUBECONFIG')]) {
                        // Deploy using Helm
                        sh '''
                            helm repo add my-helm-repo https://my-helm-repo-url # Optional: if you need to add a repo
                            helm repo update
                            helm upgrade --install $HELM_RELEASE_NAME ./helm-chart --namespace $HELM_NAMESPACE --set image.repository=$DOCKER_IMAGE --set image.tag=latest
                        '''
                    }
                }
            }
        }
    }
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed.'
            // Optionally, add notifications or other actions
        }
    }
}

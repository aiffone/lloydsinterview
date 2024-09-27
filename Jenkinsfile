pipeline {
    agent any

    triggers {
        // Trigger the pipeline on every push to the repository
        githubPush()
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from Git repository...'
                git url: 'https://github.com/aiffone/lloydsinterview.git', credentialsId: 'github-pat'
            }
        }

        stage('Authenticate with GKE') {
            steps {
                script {
                    echo 'Authenticating with Google Cloud and GKE...'
                    withCredentials([file(credentialsId: 'gke-service-account', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                        sh 'gcloud container clusters get-credentials infra1-gke-cluster --region us-central1 --project infra1-430721'
                        sh 'gcloud auth configure-docker us-central1-docker.pkg.dev'  // Configure Docker to authenticate with Artifact Registry
                    }
                }
            }
        }

        stage('Create Namespace') {
            steps {
                script {
                    echo 'Creating namespace if it does not exist...'
                    sh 'kubectl create namespace microservices || echo "Namespace already exists"'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    sh 'docker build -t us-central1-docker.pkg.dev/infra1-430721/nginx/nginx-image:latest .'  // Use a more explicit image name format
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    echo 'Pushing Docker image to repository...'
                    sh 'docker push us-central1-docker.pkg.dev/infra1-430721/nginx/nginx-image:latest'
                }
            }
        }

        stage('Deploy with Helm') {
            steps {
                script {
                    echo 'Deploying Hello World application with Helm...'
                    sh '''
                        helm upgrade --install hello-world ./helm-chart \
                        --namespace microservices \
                        --set image.repository=us-central1-docker.pkg.dev/infra1-430721/nginx/nginx-image \
                        --set image.tag=latest \
                        --debug
                    '''
                    sh 'kubectl get deployments -n microservices'  // Verify deployment
                }
            }
        }

        stage('Post Deployment Checks') {
            steps {
                script {
                    echo 'Verifying deployment...'
                    sh 'kubectl get pods -n microservices || exit 1'
                    sh 'kubectl get svc -n microservices || exit 1'
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Please check the logs for more details.'
        }
    }
}

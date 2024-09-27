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
                    // Authenticate using the service account email directly
                    sh '''
                        gcloud auth activate-service-account jenkins@infra1-430721.iam.gserviceaccount.com --key-file=$GOOGLE_APPLICATION_CREDENTIALS
                        gcloud container clusters get-credentials infra1-gke-cluster --region us-central1 --project infra1-430721
                        gcloud auth configure-docker us-central1-docker.pkg.dev  // Configure Docker to authenticate with Artifact Registry
                    '''
                }
            }
        }

        stage('Create Namespace') {
            steps {
                script {
                    echo 'Creating namespace if not exists...'
                    sh 'kubectl create namespace microservices || echo "Namespace already exists"'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    sh '''
                        docker build -t us-central1-docker.pkg.dev/infra1-430721/ngnx:latest .
                    '''
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    echo 'Pushing Docker image to repository...'
                    sh '''
                        docker push us-central1-docker.pkg.dev/infra1-430721/ngnx:latest
                    '''
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
                        --set image.repository=us-central1-docker.pkg.dev/infra1-430721/ngnx \
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

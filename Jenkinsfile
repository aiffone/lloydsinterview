pipeline {
    agent any
    environment {
        PROJECT_ID = 'infra1-430721'  // Replace with your GCP Project ID
        REGION = 'us-central1'
        CLUSTER_NAME = 'infra1-gke-cluster'
        SERVICE_ACCOUNT = 'jenkins@infra1-430721.iam.gserviceaccount.com'  // Replace with your service account if needed
    }
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building the Docker image..."
                    sh "docker build -t gcr.io/${env.PROJECT_ID}/hello-world:latest ."
                }
            }
        }
        stage('Push Docker Image to GCR') {
            steps {
                script {
                    echo "Pushing the Docker image to Google Container Registry..."
                    sh "docker push gcr.io/${env.PROJECT_ID}/hello-world:latest"
                }
            }
        }
        stage('Authenticate with GKE') {
            steps {
                script {
                    echo "Authenticating with GKE cluster..."
                    sh """
                        gcloud container clusters get-credentials ${env.CLUSTER_NAME} \
                        --region ${env.REGION} --project ${env.PROJECT_ID}
                    """
                }
            }
        }
        stage('Create Kubernetes Namespace') {
            steps {
                script {
                    echo "Creating namespace 'daemon' if it does not exist..."
                    sh """
                        kubectl get namespace daemon || kubectl create namespace daemon
                    """
                }
            }
        }
        stage('Deploy to GKE with Helm') {
            steps {
                script {
                    echo "Installing Helm and deploying the application..."
                    sh """
                        curl -s https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
                        helm upgrade --install hello-world-daemon ./hello-world/helm-chart \
                        --set image.repository=gcr.io/${env.PROJECT_ID}/hello-world \
                        --set image.tag=latest \
                        --namespace daemon \
                        --create-namespace
                    """
                }
            }
        }
    }
    post {
        always {
            echo "Pipeline completed."
        }
        success {
            echo "Deployment succeeded!"
        }
        failure {
            echo "Deployment failed."
        }
    }
}

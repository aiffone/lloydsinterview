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
                    }
                }
            }
        }

        stage('Clean Up Existing Helm Releases') {
            steps {
                script {
                    echo 'Deleting all existing Helm releases in the "microservices" namespace...'
                    // Delete all existing Helm releases in the specified namespace
                    sh '''
                        helm list --namespace microservices -q | xargs -r helm delete --namespace microservices || echo "No releases to delete."
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
                        --namespace microservices \  # Ensure this is set to microservices
                        --create-namespace \
                        --set image.repository=europe-west1-docker.pkg.dev/infra1-430721/hello/hello-world \
                        --set image.tag=latest
                    '''
                }
            }
        }

        stage('Verify Deployment Status') {
            steps {
                script {
                    echo 'Checking deployment status...'
                    // Adding a short delay to ensure Kubernetes registers the deployment before checking status
                    sleep(time: 15, unit: "SECONDS")  // Adjust the wait time as necessary

                    // Check if the deployment exists and its status
                    sh 'kubectl get deployments -n microservices || exit 1'

                    // Wait for the rollout to complete
                    sh 'kubectl rollout status deployment/hello-world -n microservices || exit 1'
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

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

        stage('Delete microservices Namespace') {
            steps {
                script {
                    echo 'Deleting the entire microservices namespace to remove conflicting resources...'
                    // Delete the entire namespace to remove all resources and avoid conflicts
                    sh 'kubectl delete namespace microservices || echo "Namespace microservices not found or already deleted."'
                }
            }
        }

        stage('Create pythonmicro Namespace') {
            steps {
                script {
                    echo 'Creating a fresh pythonmicro namespace...'
                    sh 'kubectl create namespace pythonmicro || echo "Namespace pythonmicro already exists."'
                }
            }
        }

        stage('Deploy with Helm to pythonmicro Namespace') {
            steps {
                script {
                    echo 'Deploying Hello World application with Helm to the pythonmicro namespace...'
                    sh '''
                        helm upgrade --install hello-world ./helm-chart \
                        --namespace pythonmicro \
                        --create-namespace \
                        --set image.repository=europe-west1-docker.pkg.dev/infra1-430721/hello/hello-world \
                        --set image.tag=latest \
                        --debug
                    '''
                    sh 'kubectl get deployments -n pythonmicro'  // Verify deployment in the new namespace
                }
            }
        }

        stage('Post Deployment Checks') {
            steps {
                script {
                    echo 'Verifying deployment in pythonmicro namespace...'
                    sh 'kubectl get pods -n pythonmicro || exit 1'
                    sh 'kubectl get svc -n pythonmicro || exit 1'
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

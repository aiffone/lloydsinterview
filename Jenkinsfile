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

        stage('Check Python Installation') {
            steps {
                script {
                    echo 'Checking Python installation...'
                    sh '''
                        if ! python --version 2>/dev/null; then
                            echo "Python 2 not found, checking Python 3..."
                            python3 --version
                        fi
                    '''
                }
            }
        }

        stage('Setup Python Environment') {
            steps {
                script {
                    echo 'Setting up Python virtual environment...'
                    sh '''
                        python3 -m venv venv
                        . venv/bin/activate  # Use . instead of source for compatibility
                        pip install Flask
                    '''
                }
            }
        }

        stage('Pull Hello World Image') {
            steps {
                script {
                    echo 'Pulling Hello World image from Docker Hub...'
                    sh 'docker pull hello-world'
                }
            }
        }

        stage('Tag Docker Image') {
            steps {
                script {
                    echo 'Tagging the Hello World image...'
                    sh 'docker tag hello-world europe-west1-docker.pkg.dev/infra1-430721/hello/hello-world:latest'
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
                    sh 'docker push europe-west1-docker.pkg.dev/infra1-430721/hello/hello-world:latest'
                }
            }
        }

        stage('Clean Up Existing Helm Releases') {
            steps {
                script {
                    echo 'Authenticating with GKE...'
                    withCredentials([file(credentialsId: 'gke-service-account', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                        sh 'gcloud container clusters get-credentials infra1-gke-cluster --region europe-west1 --project infra1-430721'
                    }

                    echo 'Deleting all existing Helm releases in the "microservices" namespace...'
                    // This command will delete all Helm releases in the specified namespace
                    sh '''
                        helm list --namespace microservices -q | xargs -r helm delete --namespace microservices
                    '''
                }
            }
        }

        stage('Deploy with Helm') {
            steps {
                script {
                    echo 'Deploying application with Helm...'
                    sh '''
                        helm upgrade --install hello-world ./helm-chart \
                        --namespace microservices \
                        --create-namespace \
                        --set image.repository=europe-west1-docker.pkg.dev/infra1-430721/hello/hello-world \
                        --set image.tag=latest
                    '''

                    echo 'Checking deployment status...'
                    sh 'kubectl rollout status deployment/hello-world -n microservices'
                }
            }
        }

        stage('Post Deployment Checks') {
            steps {
                script {
                    echo 'Verifying deployment...'
                    sh 'kubectl get pods -n microservices'
                    sh 'kubectl get svc -n microservices'
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

pipeline {
    agent any

    triggers {
        // Trigger the pipeline every time there is a push to the repository
        githubPush()
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the repository
                git url: 'https://github.com/aiffone/lloydsinterview.git', credentialsId: 'github-pat'
            }
        }

        stage('Check Python Installation') {
            steps {
                script {
                    echo 'Checking Python installation...'
                    // Check Python versions
                    sh 'python --version || python3 --version'
                }
            }
        }

        stage('Setup Python Environment') {
            steps {
                script {
                    echo 'Setting up Python virtual environment...'
                    // Create a virtual environment and install Flask using python3
                    sh '''
                        python3 -m venv venv
                        . venv/bin/activate  # Activate the virtual environment
                        pip install Flask
                    '''
                }
            }
        }

        stage('Pull Hello World Image') {
            steps {
                script {
                    echo 'Pulling Hello World image from Docker Hub...'
                    // Pull the hello-world image from Docker Hub 
                    sh 'docker pull hello-world'
                }
            }
        }

        stage('Tag Docker Image') {
            steps {
                script {
                    echo 'Tagging the Hello World image...'
                    // Tag the pulled image for GCR
                    sh 'docker tag hello-world europe-west1-docker.pkg.dev/infra1-430721/hello/hello-world:latest'
                }
            }
        }

        stage('Push Docker Image to Artifact Registry') {
            steps {
                script {
                    echo 'Authenticating with Google Cloud...'
                    
                    // Authenticate using the service account
                    withCredentials([file(credentialsId: 'gcr-service-account', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                        sh 'gcloud auth configure-docker europe-west1-docker.pkg.dev --quiet'
                    }
                    
                    echo 'Pushing Docker image to Artifact Registry...'
                    sh 'docker push europe-west1-docker.pkg.dev/infra1-430721/hello/hello-world:latest'
                }
            }
        }

        stage('Deploy with Helm') {
            steps {
                script {
                    echo 'Authenticating with GKE...'
                    
                    // Authenticate using the GKE service account
                    withCredentials([file(credentialsId: 'gke-service-account', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                        
                        // Get credentials for the GKE cluster
                        sh 'gcloud container clusters get-credentials infra1-gke-cluster --region europe-west1 --project infra1-430721'
                    }
                    
                    echo 'Deploying with Helm...'
                    sh '''
                        helm upgrade --install hello-world ./helm-chart \
                        --namespace microservices \
                        --set image.repository=europe-west1-docker.pkg.dev/infra1-430721/hello/hello-world \
                        --set image.tag=latest
                    '''
                }
            }
        }
    }
}

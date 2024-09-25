pipeline {
    agent any
    triggers {
        // Trigger the pipeline every time there is a push to the repository
        githubPush()
    }
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
                    sh 'docker push europe-west1-docker.pkg.dev/infra1-430721/hello/hello-world:latest'
                }
            }
        }
        stage('Deploy with Helm') {
            steps {
                script {
                    echo 'Authenticating with GKE...'
                    withCredentials([file(credentialsId: 'gke-service-account', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                        sh 'gcloud container clusters get-credentials your-cluster-name --zone your-zone --project infra1-430721'
                    }
                    echo 'Deploying with Helm...'
                    sh '''
                        helm upgrade --install hello-world ./helm-chart \
                        --namespace microservices \
                        --set image.repository=europe-west1-docker.pkg.dev/infra1-430721/hello/hello-world \
                        --set image.tag=latest \
                        --set containerPort=8081  # Updated to use port 8081
                    '''
                }
            }
        }
    }
}

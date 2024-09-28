pipeline {
    agent any

    triggers {
        githubPush()
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/aiffone/lloydsinterview.git', credentialsId: 'github-pat'
            }
        }

        stage('Authenticate with GKE') {
            steps {
                withCredentials([file(credentialsId: 'gke-service-account', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                    sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                    sh 'gcloud container clusters get-credentials infra1-gke-cluster --region us-central1 --project infra1-430721'
                }
            }
        }

        stage('Deploy with Helm') {
            steps {
                script {
                    // Adjust to the correct directory if necessary
                    sh '''
                        ls -la
                        helm upgrade --install hello-world-jenkins hello-world-jenkins \
                        --namespace pythonmicro \
                        --set image.repository=europe-west1-docker.pkg.dev/infra1-430721/hello/hello-world \
                        --set image.tag=latest
                    '''
                }
            }
        }

        stage('Post Deployment Checks') {
            steps {
                script {
                    sh 'kubectl get pods -n pythonmicro'
                    sh 'kubectl get svc -n pythonmicro'
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed. Check the logs for details.'
        }
    }
}

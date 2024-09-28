pipeline {
    agent any

    triggers {
        // Trigger the pipeline on every push to the repository
        githubPush()
    }

    stages {
        stage('Checkout') {
            steps {
                // Check out the code from the GitHub repository
                git url: 'https://github.com/aiffone/lloydsinterview.git', credentialsId: 'github-pat'
            }
        }

        stage('Authenticate with GKE') {
            steps {
                // Authenticate with Google Cloud and GKE
                withCredentials([file(credentialsId: 'gke-service-account', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                    sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                    sh 'gcloud container clusters get-credentials infra1-gke-cluster --region us-central1 --project infra1-430721'
                }
            }
        }

        stage('Deploy with Helm') {
            steps {
                script {
                    // List the contents of the workspace and deploy with Helm
                    sh '''
                        echo "Current directory contents:"
                        ls -la
                        helm upgrade --install hello-world-jenkins helm-chart \
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
                    // Verify that the deployment was successful
                    sh 'kubectl get pods -n pythonmicro'
                    sh 'kubectl get svc -n pythonmicro'
                }
            }
        }
    }

    post {
        always {
            // Clean up the workspace after the build
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

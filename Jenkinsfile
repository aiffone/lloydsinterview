pipeline {
    agent any

    stages {
        // Other stages remain unchanged...

        stage('Deploy with Helm to pythonmicro Namespace') {
            steps {
                script {
                    echo 'Deploying Hello World application with Helm to the pythonmicro namespace using hello-world-jenkins chart...'
                    
                    // Ensure we're in the right directory for the Helm chart
                    dir('hello-world-jenkins') {
                        // Debug commands to check the current directory and list contents
                        echo 'Current working directory:'
                        sh 'pwd'
                        
                        echo 'Listing contents of hello-world-jenkins directory:'
                        sh 'ls -la'

                        // Deploy using Helm
                        sh '''
                            helm upgrade --install hello-world-jenkins . \
                            --namespace pythonmicro \
                            --set image.repository=europe-west1-docker.pkg.dev/infra1-430721/hello/hello-world \
                            --set image.tag=latest \
                            --debug
                        '''
                    }

                    // Verify that the deployment has been created in the namespace
                    sh 'kubectl get deployments -n pythonmicro'
                }
            }
        }

        // Other stages remain unchanged...
    }

    // Post actions remain unchanged...
}

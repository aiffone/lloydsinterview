pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                // Check out the code from GitHub
                git url: 'https://github.com/aiffone/lloydsinterview.git', credentialsId: 'github-pat'
            }
        }
        stage('Run Groovy Script') {
            steps {
                script {
                    // Your Groovy script logic here
                    echo 'Running Groovy script...'
                    // Example: run a Groovy script file
                    // sh 'groovy your-script.groovy'
                }
            }
        }
    }
}

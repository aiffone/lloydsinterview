pipeline {
    agent any // Use any available agent

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from GitHub
                git url: 'https://github.com/aiffone/lloydsinterview.git', branch: 'master'
            }
        }
        
        stage('Run Groovy Script') {
            steps {
                // Run the Groovy script (assuming the script is located at the root)
                script {
                    // Replace 'YourScript.groovy' with the actual name of your Groovy script
                    def groovyScript = 'YourScript.groovy'
                    def groovyHome = tool name: 'groovy', type: 'groovy' // Assuming Groovy is installed on Jenkins
                    sh "${groovyHome}/bin/groovy ${groovyScript}"
                }
            }
        }
    }

    post {
        always {
            // Cleanup or notification steps can go here
            echo 'Pipeline completed.'
        }
    }
}

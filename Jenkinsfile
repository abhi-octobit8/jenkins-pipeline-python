pipeline {
    agent any

    // environment {
    //     DOCKER_IMAGE = 'your-docker-image:tag'  // Set your Docker image name and tag
    // }

    stages {
        stage('Checkout') {
            steps {
                // Check out your Django project code from your version control system (e.g., Git)
                checkout scm
            }
        }

        stage('Build and Test') {
            steps {
                // Set up a Python virtual environment
                bat 'python -m venv venv'
                bat 'venv\\scripts\\activate'

                // Install dependencies
                bat 'pip install -r requirements.txt'

                // Run Django database migrations
                bat 'python manage.py migrate'

                // Run Django tests
                bat 'python manage.py test'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    def scannerHome = tool name: 'sonar-scanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                    withSonarQubeEnv('sonar-scanner') {
                        bat "C:\\Program Files\\sonarscanner\\sonar-scanner-4.8.0.2856-windows\\bin\\sonar-scanner"
                    }
                }
            }
        }

        // stage('Build Docker Image') {
        //     steps {
        //         // Build a Docker image of your Django project
        //         sh "docker build -t $DOCKER_IMAGE ."
        //     }
        // }

        // stage('Push Docker Image') {
        //     steps {
        //         // Push the Docker image to your Docker registry
        //         withCredentials([usernamePassword(credentialsId: 'your-docker-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
        //             sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
        //             sh "docker push $DOCKER_IMAGE"
        //         }
        //     }
        // }
    }

    post {
        success {
            echo 'Build Successful'
        }

        failure {
            echo 'Build failed'
        }
    }
}

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

                bat "python manage.py collectstatic --noinput"

                bat "python setup.py sdist"
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    def scannerHome = tool name: 'sonar-scanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                    withSonarQubeEnv('sonar-scanner') {
                        bat "${scannerHome}\\sonar-scanner"
                    }
                }
            }
        }

        stage('Publish to Artifactory') {
            steps {
                script {
                    def server = Artifactory.newServer url: env.ARTIFACTORY_SERVER, credentialsId: 'your-credentials-id'
                    def uploadSpec = """{
                        "files": [
                            {
                                "pattern": "dist/*.tar.gz",
                                "target": "${env.ARTIFACTORY_REPO}/${env.DJANGO_APP_NAME}/",
                                "props": "build.name=${env.JOB_NAME};build.number=${env.BUILD_NUMBER}"
                            }
                        ]
                    }"""
                    def buildInfo = server.upload spec: uploadSpec
                    echo "Published to Artifactory: ${env.ARTIFACTORY_REPO}/${env.DJANGO_APP_NAME}/"
                }
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    // Specify your Docker image name and tag
                    def dockerImage = 'your-docker-image-name:tag'
                    
                    // Log in to the Docker registry (if needed)
                    withCredentials([usernamePassword(credentialsId: 'your-docker-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                    }
                    
                    // Push the Docker image to a container registry
                    sh "docker push $dockerImage"
                }
            }
        }

        stage('Initialize Terraform') {
            steps {
                // Initialize Terraform in your working directory
                bat 'terraform init'
            }
        }

        stage('Plan Terraform Changes') {
            steps {
                // Create an execution plan to review changes
                bat 'terraform plan -out=tfplan'
            }
        }

        stage('Apply Terraform Changes') {
            steps {
                // Apply the changes to create the AKS cluster
                bat 'terraform apply -auto-approve tfplan'
            }
        }

        stage('Deploy to AKS') {
            steps {
                script {
                    def kubeconfigPath = sh(script: 'echo $KUBECONFIG', returnStdout: true).trim()
                    
                    // Set the image for the deployment
                    sh "kubectl --kubeconfig=$kubeconfigPath set image deployment/your-deployment-name your-container-name=$IMAGE_NAME"
                }
            }
        }
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

pipeline {
    agent any

    environment {
        GIT_REPO = 'https://github.com/prudhviraj310/devsecops-demo.git'  // 🔁 Change to your actual repo URL
        IMAGE_NAME = 'my-devops-app'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: "${GIT_REPO}"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME} ."
                }
            }
        }

        stage('Trivy Vulnerability Scan') {
            steps {
                script {
                    sh "docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image ${IMAGE_NAME}"
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    sh "docker run -d -p 5173:5173 --name ${IMAGE_NAME} ${IMAGE_NAME}"
                }
            }
        }
    }
}

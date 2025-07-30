pipeline {
    agent any

    environment {
        SONAR_TOKEN = credentials('sqp_17cb931388a45e307ed0fa0a8af99744bee68665') // Jenkins credential ID for SonarQube token
        SONAR_HOST_URL = 'http://localhost:9000'
        DOCKERHUB_USER = 'prudhviraj310'
        IMAGE_NAME = 'devsecops-demo'
    }

    tools {
        nodejs 'nodejs' // This must match Jenkins Global Tool Config name
    }

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/prudhviraj310/devsecops-demo.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('MySonar') {
                    sh """
                        npx sonar-scanner \
                        -Dsonar.projectKey=devsecops-demo \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=${SONAR_HOST_URL} \
                        -Dsonar.login=${SONAR_TOKEN}
                    """
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 1, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKERHUB_USER/$IMAGE_NAME:latest .'
            }
        }

        stage('Trivy Scan') {
            steps {
                sh 'trivy image --exit-code 0 --severity HIGH,CRITICAL $DOCKERHUB_USER/$IMAGE_NAME:latest'
            }
        }

        stage('Docker Login & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $DOCKERHUB_USER/$IMAGE_NAME:latest
                    '''
                }
            }
        }
    }

    post {
        always {
            echo "🧹 Cleaning up Docker session..."
            sh 'docker logout'
        }
    }
}

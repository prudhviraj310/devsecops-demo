pipeline {
  agent any

  tools {
    nodejs 'NodeJS-20'  // Make sure this name exactly matches the NodeJS tool installed in Jenkins
  }

  environment {
    SONAR_TOKEN = credentials('sonar-token')  // This must match the ID of your SonarQube token in Jenkins credentials
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
        withSonarQubeEnv('MySonarQubeServer') {  // Ensure "MySonarQubeServer" is configured in Jenkins -> Manage Jenkins -> Configure System
          sh '''
            npx sonar-scanner \
              -Dsonar.projectKey=devsecops-demo \
              -Dsonar.sources=src \
              -Dsonar.host.url=$SONAR_HOST_URL \
              -Dsonar.login=$SONAR_TOKEN
          '''
        }
      }
    }

    stage('Quality Gate') {
      steps {
        timeout(time: 2, unit: 'MINUTES') {
          waitForQualityGate abortPipeline: true
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t devsecops-demo .'
      }
    }

    stage('Trivy Scan') {
      steps {
        sh 'trivy image devsecops-demo'
      }
    }

    stage('Docker Login & Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
          sh '''
            echo "$PASSWORD" | docker login -u "$USERNAME" --password-stdin
            docker tag devsecops-demo $USERNAME/devsecops-demo:latest
            docker push $USERNAME/devsecops-demo:latest
          '''
        }
      }
    }
  }

  post {
    always {
      echo "Cleaning up..."
      sh 'docker logout || true'
    }
  }
}

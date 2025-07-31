pipeline {
  agent any

  tools {
    nodejs 'NodeJS-20'  // Ensure NodeJS-20 is installed in Jenkins tools
  }

  environment {
    SONAR_TOKEN = credentials('sonar-token')  // Add this credential in Jenkins
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
        withSonarQubeEnv('MySonarQubeServer') {
          sh 'npx sonar-scanner -Dsonar.projectKey=devsecops-demo -Dsonar.sources=src'
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

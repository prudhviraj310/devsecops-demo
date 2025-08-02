pipeline {
  agent any

  tools {
    nodejs 'NodeJS-20'  // Must match Jenkins tool name
  }

  environment {
    SONAR_TOKEN = credentials('sonar-token')  // Jenkins credentials ID
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
          sh """
            npx sonar-scanner \
              -Dsonar.projectKey=devsecops-demo \
              -Dsonar.sources=src
          """
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

    stage('Clean Docker Cache') {
      steps {
        echo "Cleaning Docker build cache..."
        sh '''
          docker builder prune -af || true
          docker system prune -af --volumes || true
        '''
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build --no-cache -t devsecops-demo .'
      }
    }

    stage('Trivy Scan (Fail on HIGH/CRITICAL)') {
      steps {
        sh '''
          trivy image --exit-code 1 --severity HIGH,CRITICAL devsecops-demo
        '''
      }
    }

    stage('Docker Login & Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
          sh """
            echo "$PASSWORD" | docker login -u "$USERNAME" --password-stdin
            docker tag devsecops-demo $USERNAME/devsecops-demo:latest
            docker push $USERNAME/devsecops-demo:latest
          """
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

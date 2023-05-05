pipeline {
    agent any
    tools {
      maven 'maven391'
    }
    stages {
        stage('Get maven version') {
            steps {
                sh 'mvn --version '
            }
        }
    }
}

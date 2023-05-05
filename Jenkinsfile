pipeline {
    agent any
    tools {
      maven 'maven391'
    }
    stages {
        stage('echo version') {
            steps {
                sh 'mvn --version'
            }
        }
         stage('test unit') {
            steps {
                sh 'mvn test'
            }
        }
    }
}

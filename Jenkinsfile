pipeline {
    agent any
    tool{
      maven 'maven"391'
    }
    stages {
        stage('Get maven version') {
            steps {
                sh 'mvn --version '
            }
        }
    }
}

pipeline {
    agent any
    tools {
      maven 'maven391'
    }
    stages {
        stage('echo et test unitaire') {
            paralelle{
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
         stage('package') {
            steps {
                sh 'mvn package -DskipTest'
            }
        }
        
    }
}

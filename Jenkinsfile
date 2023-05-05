pipeline {
    agent any
    tools {
      maven 'maven391'
    }
    stages {
        stage('test unit') {
            steps {
                echo " my teste unit djadji samba sow"
                sh 'mvn --version'
                sh 'mvn test'
            }
        }
    }
}

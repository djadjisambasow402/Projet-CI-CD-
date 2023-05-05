pipline{
    agent any
    tools {
        'maven391'
    }
    stages {
        stage('echo et teste unitaire'){
            parallel {
                stage('version') {
                    steps {
                        sh 'mvn --version'
                    }
                }
                stage('teste unitaire') {
                    steps {
                        sh 'mvn test'
                    }
                }
            }
        }
           stage('packages') {
                        steps {
                            sh 'mvn package -DskipTest'
                        }
                    }
    }
}

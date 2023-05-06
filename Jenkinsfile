pipeline{
    agent any
    tools {
      maven 'maven391'
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
           stage('BUILD and run ') {
                        steps {
                            sh "sudo docker build -t djadjisambasow/test:v1.0.${BUILD_NUMBER} ."
                            sh 'sudo docker rm -f test'
                            sh 'sudo docker run --name test -d -p 8088:8088 djadjisambasow/test:v1.0.${BUILD_NUMBER}'

                        }
           }
        
    }
     post { 
          always { 
               archiveArtifacts artifacts: 'target/*.war'
                  }
          }
}

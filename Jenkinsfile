pipeline{
    agent any
    tools {
      maven 'maven'
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
         stage('Push sur dockerhub') {
                        steps {
                             withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                                    sh "sudo docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                                    sh " sudo docker push djadjisambasow/test:v1.0.${BUILD_NUMBER}"
                             }

                        }
           }   
    }
     post { 
          always { 
               archiveArtifacts artifacts: 'target/*.war'
                  }
          }
}

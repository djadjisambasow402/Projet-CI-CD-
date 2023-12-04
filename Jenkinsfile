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
                        bat 'mvn --version'
                    }
                }
                stage('teste unitaire') {
                    steps {
                        bat 'mvn test'
                    }
                }
            }
        }
           stage('packages') {
                        steps {
                            bat 'mvn package -DskipTest'
                        }
           }
           stage('BUILD and run ') {
                        steps {
                            bat "sudo docker build -t djadjisambasow/test:v1.0.${BUILD_NUMBER} ."
                            bat 'sudo docker rm -f test'
                            bat 'sudo docker run --name test -d -p 8088:8088 djadjisambasow/test:v1.0.${BUILD_NUMBER}'

                        }
           }
         stage('Push sur dockerhub') {
                        steps {
                             withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                                    bat "sudo docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                                    bat " sudo docker push djadjisambasow/test:v1.0.${BUILD_NUMBER}"
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

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
                            bat "docker build -t test:v1.0.${BUILD_NUMBER} ."
                            bat 'docker rm -f test'
                            bat 'docker run --name test -d -p 8088:8088 test:v1.0.${BUILD_NUMBER}'

                        }
           }
         stage('Push sur dockerhub') {
                        steps {
                             withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                                    bat "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                                    bat "docker push djadjisambasow/test:v1.0.${BUILD_NUMBER}"
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

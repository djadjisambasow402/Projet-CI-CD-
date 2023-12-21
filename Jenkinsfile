pipeline{
    agent any
    tools {
      maven 'maven3'
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
                            sh "docker build -t domoda/cd-projet:v1.0.${BUILD_NUMBER} ."
                            sh 'docker rm -f cd-projet'
                            sh 'docker run --name test -d -p 8088:8088 domoda/cd-projet:v1.0.${BUILD_NUMBER}'

                        }
           }
         stage('Push sur dockerhub') {
                        steps {
                             withCredentials([usernamePassword(credentialsId: 'dockerhub-dss', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                                    sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                                    sh "docker push domoda/cd-projet:v1.0.${BUILD_NUMBER}"
                             }

                        }
           }   
        
        stage('scan image with trivy') {
            step{
             sh "trivy image --format template --template "@/opt/templatehtml.tpl" -o rapport-scan.html domoda/cd-projet:v1.0.${BUILD_NUMBER} "   
            }

        stage('deploiement sur le cluster prod') {
            step{
             sh " "   
                }
         }

        stage('deploiement sur le cluster préprod') {
            step{
             sh " "   
                }
         }
            
     post { 
          always { 
               archiveArtifacts artifacts: 'target/*.war'
                  }
          }
}

pipeline{
    agent any
    environment {
        DOCKERHUB_USERNAME = "domoda"
        APP_NAME = "cd-projet"
        IMAGE_TAG = "v1.0.${BUILD_NUMBER}"
        IMAGE_NAME = "${DOCKERHUB_USERNAME}" + "/" + "${APP_NAME}"
        }
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
                            sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                            sh 'docker rm -f ${APP_NAME}'
                            sh 'docker run --name ${APP_NAME} -d -p 8088:8088 ${IMAGE_NAME}:${IMAGE_TAG}'

                        }
           }
         stage('Push sur dockerhub') {
                        steps {
                             withCredentials([usernamePassword(credentialsId: 'dockerhub-dss', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                                    sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                             }

                        }
           }   
        
        stage('scan image with trivy') {
            step{
             sh "trivy image --format template --template "@/opt/templatehtml.tpl" -o rapport-scan.html ${IMAGE_NAME}:${IMAGE_TAG} "   
            }
            
        stage('Updating Kubernetes deployment file'){
            steps {
                sh "cat deploiement.yml"
                sh "sed -i 's/${APP_NAME}.*/${APP_NAME}:${IMAGE_TAG}/g' deploiement.yml"
                sh "cat deploiement.yml"
            }
        }
            
        stage('Push the changed deployment file to Git'){
            steps {
                script{
                    sh """
                    git config --global user.name "dssow"
                    git config --global user.email "dssow@gainde2000.sn"
                    git add deploiement.yml
                    git commit -m 'Updated the deployment file' """
                    withCredentials([usernamePassword(credentialsId: 'gitops-repo', passwordVariable: 'pass', usernameVariable: 'user')]) {
                        sh "git push http://$user:$pass@gitlab-it.gainde2000.sn/dssow/gitops.git main" 
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

pipeline {
    agent any
    environment {
        DOCKERHUB_USERNAME = "domoda"
        APP_NAME = "cd-projet"
        IMAGE_TAG = "v1.0.${BUILD_NUMBER}"
        IMAGE_NAME = "${DOCKERHUB_USERNAME}/${APP_NAME}"
        DEPLOYMENT_FILE = "deploiement.yaml"
        TEMPLATE_FILE = "/opt/template/html.tpl"
    }
    tools {
        maven 'maven3'
    }
    stages {
        stage('echo et teste unitaire') {
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
                script {
                    sh "sudo docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                    sh 'sudo docker rm -f ${APP_NAME}' 
                    sh "sudo docker run --name ${APP_NAME} -d -p 8088:8088 ${IMAGE_NAME}:${IMAGE_TAG}" 
                }
            }
        }
        stage('Push sur dockerhub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-dss', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh "sudo docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                        sh "sudo docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                    }
                }
            }
        }
        stage('scan image with trivy') {
            steps {
                script {
                    sh "trivy image  ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

    }
    post {
        always {
            script {
                archiveArtifacts artifacts: 'target/*.war'
            }
        }
    }
}

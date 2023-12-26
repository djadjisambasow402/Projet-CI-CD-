pipeline {
    agent any
    environment {
        DOCKERHUB_USERNAME = "domoda"
        APP_NAME = "cd-projet"
        IMAGE_TAG = "v1.0.${BUILD_NUMBER}"
        IMAGE_NAME = "${DOCKERHUB_USERNAME}/${APP_NAME}"
        DEPLOYMENT_FILE = "deploiement.yaml"
        TEMPLATE_FILE = "/opt/template/html.tpl"
        DEPLOYMENT_FOLDER= "/var/lib/jenkins/deploiement"
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
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                    sh 'docker rm -f ${APP_NAME}' 
                    sh "docker run --name ${APP_NAME} -d -p 8088:8088 ${IMAGE_NAME}:${IMAGE_TAG}" 
                }
            }
        }
        stage('Push sur dockerhub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-dss', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                        sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
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

        stage('Updating Kubernetes deployment file'){
            steps {
                sh "cat ${DEPLOYMENT_FILE}"
                sh "sed -i 's/${APP_NAME}.*/${APP_NAME}:${IMAGE_TAG}/g' ${DEPLOYMENT_FILE}"
                sh "cat ${DEPLOYMENT_FILE}"
                sh "mv ${DEPLOYMENT_FILE} ${DEPLOYMENT_FOLDER}"
            }
        }
            
        stage('Checkout Code') {
            steps {
                dir("${DEPLOYMENT_FOLDER}"){
                git branch: 'main', credentialsId: 'gitops-repo', url: 'http://gitlab-it.gainde2000.sn/dssow/gitops.git'
                }
            }
        }
        stage('Update Deployment File') {
            steps {
                script {
                    dir("${DEPLOYMENT_FOLDER}"){
                    withCredentials([usernamePassword(credentialsId: 'gitops-repo', passwordVariable: 'pass', usernameVariable: 'user')]) {
                        #sh "mv ${DEPLOYMENT_FILE} ${DEPLOYMENT_FOLDER}/O-sante"
                        sh "git add ${DEPLOYMENT_FILE}"
                        sh "git commit -m 'Updated the deployment file' "
                        sh "git push https://$user:$pass@gitlab-it.gainde2000.sn/dssow/gitops.git HEAD:main"
                    }
                    }
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

pipline{
    agent any
    tools {
        'maven391'
    }
    stage{
        stage('echo et teste unitaire'){
            parallel{
                stage('version'){
                    step{
                        sh 'mvn --version'
                    }
                }
                stage('teste unitaire'){
                    step{
                        sh 'mvn test'
                    }
                }
            }
        }
          stage('packages'){
                        step{
                            sh 'mvn package -DskipTest'
                        }
                    }
    }
}

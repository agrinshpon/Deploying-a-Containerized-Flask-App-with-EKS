pipeline {
     agent any
     stages {
         stage('Linting') {
            steps {
              sh 'sudo docker run --rm -i hadolint/hadolint < ./Dockerfile'
            }
         }
         stage('Build and Push Image') {
            steps {
              withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dhpassword', usernameVariable: 'dhuser')]) {
                sh "docker build -t agrinshpon/udacity-capstone ."
                sh 'docker image ls'
                sh "docker login -u ${env.dhuser} -p ${env.dhpassword}"
                sh "docker push agrinshpon/udacity-capstone"
                        }
                  }
        }
}
}

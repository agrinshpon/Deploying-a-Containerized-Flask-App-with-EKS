pipeline {
     agent any
     stages {
         stage('Linting') {
            steps {
              sh 'docker run --rm -i hadolint/hadolint < ./Dockerfile'
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
         stage('Create Network Stack and EKS Control Plane')  {
           steps {
             withAWS(credentials: 'udacity-capstone-aws', region: 'us-east-1') {
               cfnUpdate(stack:'networkstack', file:'network.yml', paramsFile:'network-parameters.json')
            }
          }
        }
        stage('Create EKS Node Group')  {
          steps {
            withAWS(credentials: 'udacity-capstone-aws', region: 'us-east-1') {
              cfnUpdate(stack:'eksworkerstack', file:'eks-nodegroup.yml', paramsFile:'eks-nodegroup-parameters.json')
           }
         }
       }
         stage('EKS Deployment') {
           steps {
             withAWS(credentials: 'udacity-capstone-aws', region: 'us-east-1') {
               sh 'kubectl apply -f aws-auth-cm.yml'
               sh 'kubectl set image deployments/udacity-capstone udacity-capstone=agrinshpon/udacity-capstone:latest'
               sh 'kubectl apply -f udacity-capstone-deployment.yml'
               sh 'kubectl apply -f udacity-capstone-service.yml'
               sh 'kubectl get svc udacity-capstone -o yaml'
          }
          }
        }
}
}

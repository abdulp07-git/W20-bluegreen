pipeline {
    
    agent any
    
    
    environment {
        DOCKERHUB_USER = credentials('dockerhub-username')
        DOCKERHUB_PASS = credentials('dockerhub-password')
        CHART_NAME = "intogit"
        AWS_DEFAULT_REGION = "ap-south-1"
        AWS_CREDENTIALS_ID = "aws-ecr-credentials"
        AWS_ACCOUNT_ID = "021891584638"
        ECR_REPO = 'abdulp07'
        ECR_REGION = "ap-south-1"
        
        
    }


    stages {
        
        
        
        stage('Unit test'){
            steps {
                git "https://github.com/abdulp07-git/W20-bluegreen.git"
                sh 'mvn test'
            }
        }
        
        stage('Build app'){
            steps {
                sh 'mvn clean package'
                archiveArtifacts artifacts: '**/target/*.war', allowEmptyArchive: true
            }
        }
        
        stage("create application image"){
            steps {
                script {
                    //def dockerImage = "abdulp07/tomcat_helm"
                    //def tag = "v${BUILD_NUMBER}"
                    //def fullImageName = "${dockerImage}:${tag}"
                    sh "docker build -t abdulp07/intogit_bluegreen:v${BUILD_NUMBER} ."
                    
                }
                
            }
        }
        
        stage("Push image to docker hub"){
            steps {
                script {
                    //def dockerImage = "abdulp07/tomcat_helm"
                    //def tag = "v${BUILD_NUMBER}"
                    //def fullImageName = "${dockerImage}:${tag}"
                    
                    sh '''
                    #!/bin/bash
                    
         echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin
                    '''

                    sh "docker push abdulp07/intogit_bluegreen:v${BUILD_NUMBER}"
                    
                }
            }
            
            post {
                always {
                    sh 'docker logout'
                    sh 'docker rmi abdulp07/intogit_bluegreen:v${BUILD_NUMBER}'
                }
            }
        }
        
        
        stage ("Update new tag in Charts"){
            steps {
                sh './replacetag.sh'
                sh 'helm package $CHART_NAME'
                
            }
        }
        
        
        stage('Login to AWS ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${AWS_CREDENTIALS_ID}"]]) {
                    script {
                        // Log in to AWS ECR
                        sh '''
                            aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | \
                            helm registry login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com
                        '''
                    }
                }
            }
        }
        
        
        stage('Push Helm Chart to ECR') {
            steps {
                script {
                    // Push the Helm chart to ECR
                    sh """
    # Check if the repository exists

    
    # Push the Helm chart to the ECR repository
    helm push ${CHART_NAME}-0.1.${BUILD_NUMBER}.tgz oci://${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com
"""
                }
            }
        
            post {
                always {
                    sh 'rm -f ${CHART_NAME}-0.1.${BUILD_NUMBER}.tgz'
                }
            }
            
        }
        
        
        
        
    }//steps end here
}


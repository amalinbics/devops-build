pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE_DEV = credentials('docker-image-dev')
        DOCKER_IMAGE_PROD = credentials('docker-image-prod')
        DOCKER_TAG = "${BUILD_NUMBER}"
        DOCKER_CREDENTIALS = credentials('docker-cred')
        SSH_CREDENTIALS = credentials('ssh-key')
        REMOTE_SERVER_USER_NAME = credentials('remote-server-username')
    }
    
    stages {

        stage('Docker Build and Push') {
            steps {
                script {
                    sh 'echo $DOCKER_CREDENTIALS_PSW | docker login -u $DOCKER_CREDENTIALS_USR --password-stdin'
                    
                    // Make scripts executable
                    sh 'chmod +x deployment-scripts/build.sh'
                    sh 'chmod +x deployment-scripts/deploy.sh'
                    
                    if (env.BRANCH_NAME == 'dev') {
                        // Build and push to dev repository
                        sh """
                            export IMAGE_NAME=${DOCKER_IMAGE_DEV}
                            export IMAGE_TAG=${DOCKER_TAG}
                            ./deployment-scripts/build.sh
                            docker push ${DOCKER_IMAGE_DEV}:${DOCKER_TAG}
                            docker tag ${DOCKER_IMAGE_DEV}:${DOCKER_TAG} ${DOCKER_IMAGE_DEV}:latest
                            docker push ${DOCKER_IMAGE_DEV}:latest
                        """
                    } else if (env.BRANCH_NAME == 'main') {
                        // Build and push to prod repository
                        sh """
                            export IMAGE_NAME=${DOCKER_IMAGE_PROD}
                            export IMAGE_TAG=${DOCKER_TAG}
                            ./deployment-scripts/build.sh
                            docker push ${DOCKER_IMAGE_PROD}:${DOCKER_TAG}
                            docker tag ${DOCKER_IMAGE_PROD}:${DOCKER_TAG} ${DOCKER_IMAGE_PROD}:latest
                            docker push ${DOCKER_IMAGE_PROD}:latest
                        """
                    }
                }
            }
        }
        
        stage('Deploy to Dev') {
            when {
                branch 'dev'
            }
            steps {
                script {
                    echo "Deploying to development server at ${env.DEV_SERVER_IP}"
                    def remote = [:]
                    remote.name = 'dev-server'
                    remote.host = env.DEV_SERVER_IP
                    remote.allowAnyHosts = true
                    remote.user = ${REMOTE_SERVER_USER_NAME}
                    remote.identityFile = SSH_CREDENTIALS
                    
                    // Copy deployment scripts to remote server
                    sshPut remote: remote, from: 'deployment-scripts/deploy.sh', into: '.'
                    
                    // Make script executable and run with appropriate parameters
                    sshCommand remote: remote, command: """
                        chmod +x deploy.sh
                        docker pull ${DOCKER_IMAGE_DEV}:latest
                        export IMAGE_NAME=${DOCKER_IMAGE_DEV}
                        export IMAGE_TAG=latest
                        export CONTAINER_NAME=final-project-dev
                        ./deploy.sh
                    """
                    
                    echo "Development build deployed successfully!"
                }
            }
        }
        
        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            input {
                message "Deploy to production?"
                ok "Yes"
            }
            steps {
                script {
                    def remote = [:]
                    remote.name = 'prod-server'
                    remote.host = env.PROD_SERVER_IP
                    remote.allowAnyHosts = true
                    remote.user = ${REMOTE_SERVER_USER_NAME}
                    remote.identityFile = SSH_CREDENTIALS
                    
                    // Copy deployment scripts to remote server
                    sshPut remote: remote, from: 'deployment-scripts/deploy.sh', into: '.'
                    
                    // Make script executable and run with appropriate parameters
                    sshCommand remote: remote, command: """
                        chmod +x deploy.sh
                        docker pull ${DOCKER_IMAGE_PROD}:latest
                        export IMAGE_NAME=${DOCKER_IMAGE_PROD}
                        export IMAGE_TAG=latest
                        export CONTAINER_NAME=final-project-prod
                        ./deploy.sh
                    """
                    
                    echo "Production build deployed successfully!"
                }
            }
        }
    }
    
    post {
        always {
            sh 'docker logout'
            cleanWs()
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}

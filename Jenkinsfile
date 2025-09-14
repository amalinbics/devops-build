pipeline {
    agent any
     environment {
        DOCKER_IMAGE_DEV = credentials('DOCKER_IMAGE_DEV')
        DOCKER_IMAGE_PROD = credentials('DOCKER_IMAGE_PROD')
        DOCKER_TAG = "${BUILD_NUMBER}"
        DOCKER_CREDENTIALS = credentials('DOCKER_CRED')
        SSH_CREDENTIALS = credentials('SERVER_KEY')
        REMOTE_SERVER_USER_NAME = credentials('REMOTE_SERVER_USERNAME')
        DEV_SERVER_IP = credentials('DEV_SERVER_IP')
    }
    stages{
        stage('Build'){
            steps{
                script{
                    if (env.BRANCH_NAME == 'dev') {
                        sshagent(['SERVER_KEY']) {

                                sh """
                                #!/bin/bash
                                # Copy script to remote server
                                scp -o StrictHostKeyChecking=no -r ./* ${REMOTE_SERVER_USER_NAME}@${DEV_SERVER_IP}:/tmp/devops-build/

                                # Run the script on remote server
                                ssh -o StrictHostKeyChecking=no ${REMOTE_SERVER_USER_NAME}@${DEV_SERVER_IP} '
                                export DOCKER_USER="${DOCKER_CREDENTIALS_USR}" &&
                                export DOCKER_PASS="${DOCKER_CREDENTIALS_PSW}" && 
                                chmod +x /tmp/devops-build/build.sh && /tmp/devops-build/build.sh ${DOCKER_IMAGE_DEV} ${DOCKER_TAG}'
                                """
                            }
                        
                    }
                    else if (env.BRANCH_NAME == 'main') {
                        sshagent(['SERVER_KEY']) {
                              
                                                        
                                echo '${DOCKER_CREDENTIALS_USR}'
                                echo '${DOCKER_CREDENTIALS_PSW}'

                                sh '''#!/bin/bash
                                # Copy script to remote server
                                scp -o StrictHostKeyChecking=no -r ./* ${REMOTE_SERVER_USER_NAME}@${DEV_SERVER_IP}:/tmp/devops-build/

                                # Run the script on remote server
                                ssh -o StrictHostKeyChecking=no ${REMOTE_SERVER_USER_NAME}@${DEV_SERVER_IP} "chmod +x /tmp/devops-build/build.sh && /tmp/devops-build/build.sh ${DOCKER_IMAGE_PROD} ${DOCKER_TAG} ${$DOCKER_CREDENTIALS_USR} ${$DOCKER_CREDENTIALS_PSW}"
                                '''
                            
                        }
                    }
                }
            }
        }
        stage('Deploy to Dev') {
            when {
                branch 'dev'
            }
            steps {
                echo "Deploying to development server at ${DEV_SERVER_IP}"
                sshagent(['SERVER_KEY']) {
                    sh """#!/bin/bash
                    # Run the script on remote server
                    ssh -o StrictHostKeyChecking=no ${REMOTE_SERVER_USER_NAME}@${DEV_SERVER_IP} ' 
                    export DOCKER_USER="${DOCKER_CREDENTIALS_USR}" &&
                    export DOCKER_PASS="${DOCKER_CREDENTIALS_PSW}" && 
                    chmod +x /tmp/devops-build/deploy.sh && /tmp/devops-build/deploy.sh e-commerce-app ${DOCKER_IMAGE_DEV}'
                    """
                }
                echo 'Development build deployed successfully!'  
            }
        }
        stage('Deploy to Prod') {
            when {
                branch 'main'
            }
            steps {
                echo "Deploying to production server at ${DEV_SERVER_IP}"
                sshagent(['SERVER_KEY']) {
                    sh '''#!/bin/bash
                    # Run the script on remote server
                    ssh -o StrictHostKeyChecking=no ${REMOTE_SERVER_USER_NAME}@${DEV_SERVER_IP} "chmod +x /tmp/devops-build/deploy.sh && /tmp/devops-build/deploy.sh final-project ${DOCKER_IMAGE_PROD} ${$DOCKER_CREDENTIALS_USR} ${$DOCKER_CREDENTIALS_PSW}"
                    '''
                }
                echo 'Production build deployed successfully!'  
            }
        }
    }
}
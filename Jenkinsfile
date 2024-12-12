pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my-login-app'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                url: 'https://github.com/kiiaseilonen/login-tests-with-docker.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE, '.')
                }
            }
        }

        stage('Start Docker Container') {
            steps {
                script {
                    sh """docker rm -f my-login-app || true
                    """
                    sh """
                        docker run -d -p 5000:5000 --name my-login-app ${DOCKER_IMAGE}
                    """
                }
            }
        }

         stage('Run Tests') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'my-username', variable: 'USERNAME'),
                                     string(credentialsId: 'my-password', variable: 'PASSWORD'),
                                     string(credentialsId: 'my-invalid-username', variable: 'INVALID_USERNAME'),
                                     string(credentialsId: 'my-invalid-password', variable: 'INVALID_PASSWORD')]) {
                         sh """
                            docker exec my-login-app robot -v my-username:${env.USERNAME} -v my-password:${env.PASSWORD} -v my-invalid-username:${env.INVALID_USERNAME} -v my-invalid-password:${env.INVALID_PASSWORD} /app/test/tests/login_test.robot
                            """
                    }
                }
            }
        }

        stage('Publish Results') {
            steps {
                archiveArtifacts artifacts: '**/output.xml', allowEmptyArchive: true
                junit '**/output.xml'
            }
        }
    }
}

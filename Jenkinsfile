pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my-login-app'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/kiiaseilonen/login-tests-with-docker.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE, '.')
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'username', variable: 'USERNAME'),
                                     string(credentialsId: 'password', variable: 'PASSWORD'),
                                     string(credentialsId: 'invalid-username', variable: 'INVALID_USERNAME'),
                                     string(credentialsId: 'invalid-password', variable: 'INVALID_PASSWORD')]) {
                        docker.image(DOCKER_IMAGE).inside('-p 5000:5000') {
                            sh 'robot /app/test/tests/login_test.robot'
                        }
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

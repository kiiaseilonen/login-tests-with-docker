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
                    docker.build(DOCKER_IMAGE, "${env.WORKSPACE}")

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
                         docker.image(DOCKER_IMAGE).inside("-v ${env.WORKSPACE}:/workspace -w /workspace") {
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

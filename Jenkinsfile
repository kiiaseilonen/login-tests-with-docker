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
                    sh 'docker rm -f my-login-app || true'
                    sh 'docker run -d -p 5000:5000 --name my-login-app ${DOCKER_IMAGE}'
                }
            }
        }

       stage('Run Tests') {
         environment {
                J_USERNAME = credentials('my-username')
                J_PASSWORD = credentials('my-password')
                J_INVALID_USERNAME = credentials('my-invalid-username')
                J_INVALID_PASSWORD = credentials('my-invalid-password')
            }
            steps {
                script {
                    sh "
                         docker ps
                         docker exec my-login-app sh -c 'curl http://localhost:5000'
                         docker exec my-login-app sh -c 'robot -v USERNAME:$J_USERNAME -v PASSWORD:$J_PASSWORD -v INVALID_USERNAME:$J_INVALID_USERNAME -v INVALID_PASSWORD:$J_INVALID_PASSWORD /app/test/tests/login_test.robot'
                    "
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

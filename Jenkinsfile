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
                    sh """
                         docker ps
                         docker exec my-login-app sh -c "curl http://localhost:5000"
                         docker exec my-login-app sh -c "robot -v USERNAME:${my-username} -v PASSWORD:${my-password} -v INVALID_USERNAME:${my-invalid-username} -v INVALID_PASSWORD:${my-invalid-password} /app/test/tests/login_test.robot"
                    """
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

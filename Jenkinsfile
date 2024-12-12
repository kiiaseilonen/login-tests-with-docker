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
            environment {
                USERNAME = credentials('my-username')
                PASSWORD = credentials('my-password')
                INVALID_USERNAME = credentials('my-invalid-username')
                INVALID_PASSWORD = credentials('my-invalid-password')
            }
            steps {
                script {
                    echo "user: $USERNAME"
                    echo "pass: $PASSWORD"
                    echo "invalid user: $INVALID_USERNAME"
                    echo "invalid pass: $INVALID_PASSWORD"
                    
                    sh """
                         docker exec my-login-app sh -c "robot -v USERNAME:${USERNAME} -v PASSWORD:${PASSWORD} -v INVALID_USERNAME:${INVALID_USERNAME} -v INVALID_PASSWORD:${INVALID_PASSWORD} /app/test/tests/login_test.robot"
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

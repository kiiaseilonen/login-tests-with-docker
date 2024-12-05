pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my-login-app'
        WORKSPACE_PATH = "${env.WORKSPACE}" // Tämä määrittää Jenkinsin työtilan polun
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/kiiaseilonen/login-tests-with-docker.git'
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
                    withCredentials([string(credentialsId: 'my-username', variable: 'USERNAME'),
                                    string(credentialsId: 'my-password', variable: 'PASSWORD'),
                                    string(credentialsId: 'my-invalid-username', variable: 'INVALID_USERNAME'),
                                    string(credentialsId: 'my-invalid-password', variable: 'INVALID_PASSWORD')]) {
                        if (isUnix()) {
                            docker.image(DOCKER_IMAGE).inside("-v ${WORKSPACE_PATH}:/workspace -w /workspace") {
                                sh 'robot /workspace/test/tests/login_test.robot'
                            }
                        } else {
                            def dockerWorkspace = 'C:/ProgramData/Jenkins/.jenkins/workspace/login-demo'
                            def dockerVolume = dockerWorkspace.replaceAll('^C:','/c')
                            bat """
                                docker run -d -t -v ${dockerVolume}:/workspace -w /workspace ${DOCKER_IMAGE} robot /workspace/test/tests/login_test.robot --output /workspace/test-output.xml
                                docker logs ${containerId} # Tulostaa testikontin lokit
                            """

                        }
                    }
                }
            }
        }

        stage('Publish Results') {
            steps {
                archiveArtifacts artifacts: 'test/test-output.xml', allowEmptyArchive: true
                junit '**/test-output.xml'
            }
        }
    }
}

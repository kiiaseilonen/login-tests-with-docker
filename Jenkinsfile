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
                                sh 'robot /workspace/test/tests/login_test.robot --output /workspace/test-output.xml'
                            }
                        } else {
                            def dockerWorkspace = 'C:/ProgramData/Jenkins/.jenkins/workspace/login-demo'
                            def dockerVolume = dockerWorkspace.replaceAll('^C:', '/c')

                            def containerId = bat(script: "docker run -d -t -v ${dockerVolume}:/workspace -w /workspace ${DOCKER_IMAGE} robot /workspace/test/tests/login_test.robot --output /workspace/test-output.xml", returnStdout: true).trim()

                            // Kopioi testitulokset Jenkinsin työtilaan
                            bat "docker cp ${containerId}:/workspace/test-output.xml ${WORKSPACE}/test-output.xml"

                            // Poista kontti
                            bat "docker rm -f ${containerId}"
                        }
                    }
                }
            }
        }

        stage('Publish Results') {
            steps {
                // Arkistoi testitulokset
                archiveArtifacts allowEmptyArchive: true, artifacts: 'test-output.xml'
                
                // Käytä junit-raporttia
                junit 'test-output.xml'
            }
        }
    }
}

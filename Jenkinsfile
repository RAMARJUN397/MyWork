pipeline {
    agent { label 'Jenkins-demo' }

    environment {
        ARTIFACTORY_URL = 'https://localhost:8981/artifactory'
        REPO_PATH = 'arjun-mvn-local/com/javatechie/arjun-application/0.0.1-SNAPSHOT/arjun-application-0.0.1.zip'
        LOCAL_PATH = 'C:\\Users\\arjuna\\Downloads\\arjun-application-0.0.1.zip'
        SONARQUBE_TOKEN = credentials('Arjun_SonarQube_SCRT')
    }

    stages {

        stage('Git Checkout') {
            steps {
                echo '🔄 Checking out source code from Git...'
                git branch: 'master',
                    credentialsId: 'veesam_mallikarjunaGH',
                    url: 'https://github.com/RAMARJUN397/BankingApplication.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                echo '🔍 Running SonarQube analysis...'
                bat """
                    mvn sonar:sonar ^
                    -Dsonar.host.url=https://localhost:9000 ^
                    -Dsonar.login=%SONARQUBE_TOKEN% ^
                    -Dsonar.projectKey=arjavawebapplication ^
                    -Dsonar.projectName=arjavawebapplication ^
                    -Dsonar.sourceEncoding=UTF-8 ^
                    -Dsonar.java.source=1.7 ^
                    -Dsonar.java.target=1.7 ^
                    -Dsonar.projectVersion=1.0 ^
                    -Dsonar.sources=src/main/java ^
                    -Dsonar.java.binaries=.
                """
            }
        }

        stage('Build') {
            steps {
                echo '⚙️ Building the WAR file...'
                bat 'mvn clean install war:war'
            }
        }

        stage('JFrog Upload (Deploy)') {
            steps {
                echo '📤 Uploading artifact to JFrog Artifactory...'
                bat 'mvn deploy'
            }
        }

        stage('JFrog Download Artifact') {
            steps {
                echo '📥 Downloading artifact from JFrog Artifactory...'
                withCredentials([usernamePassword(credentialsId: 'MyJFrog_ABSECRET', usernameVariable: 'ARTIFACTORY_USER', passwordVariable: 'ARTIFACTORY_PASSWORD')]) {
                    bat """
                        curl -u %ARTIFACTORY_USER%:%ARTIFACTORY_PASSWORD% ^
                        -o "%LOCAL_PATH%" ^
                        "%ARTIFACTORY_URL%/%REPO_PATH%"
                    """
                }
            }
        }

        stage('UAT Deployment to Tomcat') {
            steps {
                echo '🚀 Deploying WAR to Tomcat UAT environment...'
                deploy adapters: [
                    tomcat9(
                        credentialsId: 'ARTomcat_credentials',
                        path: '/',
                        url: 'http://localhost:8080/'
                    )
                ],
                contextPath: '/arjunstore',
                war: 'target/arjun-application-0.0.1.war'
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully.'
        }
        failure {
            echo '❌ Pipeline failed. Check logs for details.'
        }
    }
}

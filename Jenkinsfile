def COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger'

]
pipeline {
    agent any
    tools {
        maven "MAVEN3.9.9"
        jdk "JDK17"
    }
    
    environment {
        SNAP_REPO = 'vprofile-snapshot'
		NEXUS_USER = 'admin'
		NEXUS_PASS = 'admin123'
		RELEASE_REPO = 'vprofile-release'
		CENTRAL_REPO = 'vpro-maven-central'
		NEXUSIP = '172.31.82.94'
		NEXUSPORT = '8081'
		NEXUS_GRP_REPO = 'vpro-maven-group'
        NEXUS_LOGIN = 'nexuslogin'
        SONARSERVER = 'sonarserver'
        SONARSCANNER = 'sonarscanner'
        ARTIFACT_NAME = "vprofile-v${env.BUILD_ID}.war"
        AWS_S3_BUCKET = 'vprocicdbean-10.08'
        AWS_EB_APP_NAME = 'vproapp'
        AWS_EB_ENVIRONMENT = 'Vproapp-env'
        AWS_EB_APP_VERSION = "${BUILD_ID}"

    }

    stages {
        stage('Build'){
            steps {
                sh 'mvn -s settings.xml -DskipTests install'
            }

            post {
                success {
                    echo "Now Archiving the Artifacts"
                    archiveArtifacts artifacts: '**/*.war'
                    echo "Artifacts Archived Successfully"
                }
            }
        }

        stage('test') {
            steps {
                echo "Running Test"
                sh 'mvn -s settings.xml test'
            }
        }

        stage('Checkstyle Analysis') {
            steps {
                echo "Running Checkstyle Analysis"
                sh 'mvn -s settings.xml checkstyle:checkstyle'
            }
        }

        stage('SonarQube Analysis') {
            environment {
                scannerHome = tool "${SONARSCANNER}"
            }
            steps {
                echo "Running SonarQube Analysis"
                withSonarQubeEnv("${SONARSERVER}") {
                    sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vprofile \
                    -Dsonar.projectName=vprofile \
                    -Dsonar.projectVersion=1.0 \
                    -Dsonar.sources=src/ \
                    -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                    -Dsonar.junit.reportsPath=target/surefire-reports/ \
                    -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                    -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
                }
            }

            
        }

      stage('Qulity Gate') {
                steps {
                    echo "Waiting for SonarQube Quality Gate"
                    timeout(time: 10, unit: 'MINUTES') {
                  waitForQualityGate abortPipeline: true
                    }
                }
            }

            
            stage('Upload Artifacts to Nexus') {
               
                        steps {
                           nexusArtifactUploader(
                              nexusVersion: 'nexus3',
                              protocol: 'http',
                              nexusUrl: "${NEXUSIP}:${NEXUSPORT}",
                              groupId: 'QA',
                              version: "${env.BUILD_ID}-${BUILD_TIMESTAMP}",
                              repository: "${RELEASE_REPO}",
                              credentialsId: "${NEXUS_LOGIN}",
                              artifacts: [
                                [ artifactId: 'vprofile',
                                  classifier: '',
                                  file: 'target/vprofile-v2.war',
                                  type: 'war'
                               ]
                             ]
                           )
                    }
                    
                }


            stage('Deploy to Stage Bean'){
          steps {
            withAWS(credentials: 'awsbeancreds', region: 'us-east-1') {
               sh """
                   aws s3 cp ./target/vprofile-v2.war s3://$AWS_S3_BUCKET/${ARTIFACT_NAME}
                   aws elasticbeanstalk create-application-version --application-name $AWS_EB_APP_NAME --version-label $AWS_EB_APP_VERSION --source-bundle S3Bucket=$AWS_S3_BUCKET,S3Key=${ARTIFACT_NAME}
                   aws elasticbeanstalk update-environment --application-name $AWS_EB_APP_NAME --environment-name $AWS_EB_ENVIRONMENT --version-label $AWS_EB_APP_VERSION
                """
            }
          }
        }




            }


            post {
                always {
                    echo "Slack Notification"
                    slackSend channel: '#vprofile-jenkins',
                              color: COLOR_MAP[currentBuild.currentResult],
                              message: "*${currentBuild.currentResult}:* Job '${env.JOB_NAME}' build (${env.BUILD_NUMBER}) , \n more info at ${env.BUILD_URL} "
                }
   

	    
        }
    }

node {
	def server = Artifactory.newServer url: 'http://127.0.0.1:8081/artifactory/', username: 'admin', password: 'Jijimon27'
	def rtMaven = Artifactory.newMavenBuild()
	def buildInfo
	def mvnHome
	def TESTER
	
	
	try {
	
		notifyBuild('STARTED')
	
		stage('SCM Checkout') {
			git url: 'https://github.com/ow410775/hello-world.git'
			mvnHome = tool 'M3'
		}
	
		stage('Clean') {
        	sh "mvn clean"
		}
	
		stage('Maven Test') {
			sh "mvn test"
		}
	
		stage ('Configurations') {
			rtMaven.tool = 'M3' // Tool name from Jenkins configuration
			rtMaven.deployer releaseRepo: 'libs-release-local', snapshotRepo: 'libs-snapshot-local', server: server
			buildInfo = Artifactory.newBuildInfo() // Publishing build-info to Artifactory
			buildInfo.env.capture = true
			TESTER = 'DevOps-GROUP4'
		}
	
		stage('Sonarqube Quality Gate') {
			def scannerHome = tool 'SonarQubeScanner';
			echo 'Initiating SonarQube test'
			
			withSonarQubeEnv('SonarQube') { 
				sleep 10
				echo "The tester is ${TESTER}"
				sleep 20
				echo "This is build number ${BUILD_ID}"
				
				sh 'mvn sonar:sonar -Dsonar.projectKey=DevOps_CaseStudy -Dsonar.host.url=http://127.0.0.1:9000 -Dsonar.projectVersion=helloworld-1.0.0.${BUILD_NUMBER}-SNAPSHOT.war -Dlicense.skip=true'
			}
			
			echo 'SonarQube Test Complete'
		}
	
		stage ('Execute Maven Build and Package') {
			rtMaven.run pom: 'pom.xml', goals: '-Dmaven.test.skip=true install -Dv=${BUILD_NUMBER} package', buildInfo: buildInfo
		}
	
		stage ('Publish Build Info, Upload and Deploy') {
			sh 'cp /var/lib/jenkins/.m2/repository/com/example/webapp/1.0.0.${BUILD_NUMBER}-SNAPSHOT/webapp-1.0.0.${BUILD_NUMBER}-SNAPSHOT.war /opt/tomcat/webapps'
		
			def uploadSpec = """{
				"files": [
					{
					"pattern": "/var/lib/jenkins/.m2/repository/com/example/webapp/1.0.0.${BUILD_NUMBER}-SNAPSHOT/webapp-1.0.0.${BUILD_NUMBER}-SNAPSHOT.war",
					"target": "DevOps-Repo/${BUILD_NUMBER}/"
					}
				]
			}"""
		
			server.upload spec: uploadSpec, buildInfo: buildInfo
			server.publishBuildInfo buildInfo
			server.upload spec: uploadSpec, failNoOp: true
		}
	
		//stage ('Slack Notification') {
		//	slackSend baseUrl: 'https://hooks.slack.com/services/', 
		//	channel: '#devopscasestudy', 
		//	color: 'good', 
		//	message: 'Jenkins Pipeline - ${JOB_NAME} Started: Build ${BUILD_NUMBER}', 
		//	teamDomain: 'devops-bootcamp-group', 
		//	tokenCredentialId: 'slack-devops'
		//}
		
	} catch (e) {
		// If there was an exception thrown, the build failed
		currentBuild.result = "FAILED"
		throw e
	} finally {
		// Success or failure, always send notifications
		notifyBuild(currentBuild.result)
	}
}

def notifyBuild(String buildStatus = 'STARTED') {
	// build status of null means successful
	buildStatus =  buildStatus ?: 'SUCCESSFUL'

	// Default values
	def colorName = 'RED'
	def colorCode = '#FF0000'
	def subject = "${buildStatus}: Job '${JOB_NAME} [${BUILD_NUMBER}]'"
	def summary = "${subject} (${BUILD_URL})"
	def details = """<p>STARTED: Job '${JOB_NAME} [${BUILD_NUMBER}]':</p>
	<p>Check console output at &QUOT;<a href='${BUILD_URL}'>${JOB_NAME} [${BUILD_NUMBER}]</a>&QUOT;</p>"""

	// Override default values based on build status
	if (buildStatus == 'STARTED') {
		color = 'YELLOW'
		colorCode = '#FFFF00'
	} else if (buildStatus == 'SUCCESSFUL') {
		color = 'GREEN'
		colorCode = '#00FF00'
	} else {
		color = 'RED'
		colorCode = '#FF0000'
	}

	// Send notifications
	//slackSend (color: colorCode, message: summary)
	slackSend baseUrl: 'https://hooks.slack.com/services/', 
		channel: '#devopscasestudy', 
		color: colorCode, 
		message: summary, 
		teamDomain: 'devops-bootcamp-group', 
		tokenCredentialId: 'slack-devops'

	//emailext(
	//	subject: subject,
	//	body: details,
	//	recipientProviders: [[$class: 'DevelopersRecipientProvider']]
	//)
}

node {
	def server = Artifactory.newServer url: 'http://127.0.0.1:8081/artifactory/', username: 'admin', password: 'Jijimon27'
	def rtMaven = Artifactory.newMavenBuild()
	def buildInfo
	def mvnHome
	def TESTER
	
	try {
	
		notifyBuild('STARTED')
	
		stage('SCM Checkout') {
			echo 'Initiating SCM Checkout...'
			git url: 'https://github.com/ow410775/hello-world.git'
			mvnHome = tool 'M3'
			
			slackSend baseUrl: 'https://hooks.slack.com/services/', channel: '#devopscasestudy', color: '#BDFFC3', message: 'SCM Checkout Completed!', teamDomain: 'devops-bootcamp-group', tokenCredentialId: 'slack-devops'
		}
	
		stage('Clean') {
			echo 'Initiating Maven Clean...'
        	sh "mvn clean"
			
			slackSend baseUrl: 'https://hooks.slack.com/services/', channel: '#devopscasestudy', color: '#BDFFC3', message: 'Maven Clean has been Completed!', teamDomain: 'devops-bootcamp-group', tokenCredentialId: 'slack-devops'
		}
	
		stage('Maven Test') {
			echo 'Initiating Maven Unit Test...'
			sh "mvn test"
			
			slackSend baseUrl: 'https://hooks.slack.com/services/', channel: '#devopscasestudy', color: '#BDFFC3', message: 'Maven Test has been Completed!', teamDomain: 'devops-bootcamp-group', tokenCredentialId: 'slack-devops'
		}
		
		stage('Sonarqube Quality Gate') {
			rtMaven.tool = 'M3' // Tool name from Jenkins configuration
			rtMaven.deployer releaseRepo: 'libs-release-local', snapshotRepo: 'libs-snapshot-local', server: server
			buildInfo = Artifactory.newBuildInfo() // Publishing build-info to Artifactory
			buildInfo.env.capture = true
			TESTER = 'DevOps-GROUP4'
			
			def scannerHome = tool 'SonarQubeScanner';
			echo 'Initiating SonarQube test...'
			
			withSonarQubeEnv('SonarQube') { 
				sleep 10
				echo "The tester is ${TESTER}"
				sleep 20
				echo "This is build number ${BUILD_ID}"
				
				sh 'mvn sonar:sonar -Dsonar.projectKey=DevOps_CaseStudy -Dsonar.host.url=http://127.0.0.1:9000 -Dsonar.projectVersion=helloworld-1.0.0.${BUILD_NUMBER}-SNAPSHOT.war -Dlicense.skip=true'
			}

			slackSend baseUrl: 'https://hooks.slack.com/services/', channel: '#devopscasestudy', color: '#BDFFC3', message: 'SonarQube Analysis Completed!', teamDomain: 'devops-bootcamp-group', tokenCredentialId: 'slack-devops'
		}
	
		stage ('Execute Maven Build and Package') {
			echo 'Initiating Build and Package Stage...'
			rtMaven.run pom: 'pom.xml', goals: '-Dmaven.test.skip=true install -Dv=${BUILD_NUMBER} package', buildInfo: buildInfo
			
			slackSend baseUrl: 'https://hooks.slack.com/services/', channel: '#devopscasestudy', color: '#BDFFC3', message: 'Build completed and Packaged WebApp', teamDomain: 'devops-bootcamp-group', tokenCredentialId: 'slack-devops'
		}
	
		stage ('Publish Build Info and Upload Code') {
			echo 'Initiating Publishing and Uploading Stage...'
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
			
			slackSend baseUrl: 'https://hooks.slack.com/services/', channel: '#devopscasestudy', color: '#BDFFC3', message: 'Build Info and Code uploaded to Artifactory!', teamDomain: 'devops-bootcamp-group', tokenCredentialId: 'slack-devops'
		}
		
		stage ('Deployment') {
			echo 'Initiating DEployment of Code...'
			sh 'cp /var/lib/jenkins/.m2/repository/com/example/webapp/1.0.0.${BUILD_NUMBER}-SNAPSHOT/webapp-1.0.0.${BUILD_NUMBER}-SNAPSHOT.war /opt/tomcat/webapps'
			
			slackSend baseUrl: 'https://hooks.slack.com/services/', channel: '#devopscasestudy', color: '#BDFFC3', message: 'Code Deployed to Tomcat!', teamDomain: 'devops-bootcamp-group', tokenCredentialId: 'slack-devops'
		}
		
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
	buildStatus =  buildStatus ?: 'SUCCESS'

	// Default values
	def colorName = 'RED'
	def colorCode = '#FF0000'
	def subject = "${buildStatus}: Job `${JOB_NAME}` #${BUILD_NUMBER}"
	def summary = "${subject}:\n${BUILD_URL}"
	def details = """
	Current status of Job ${JOB_NAME} #${BUILD_NUMBER} is: ${buildStatus}\n
	Check console output at ${JOB_NAME}[${BUILD_NUMBER}] -- ${BUILD_URL}
	"""

	// Override default values based on build status
	if (buildStatus == 'STARTED') {
		color = 'GRAY'
		colorCode = '#D4DADF'
	} else if (buildStatus == 'SUCCESS') {
		color = 'GREEN'
		colorCode = '#00FF00'
	} else if (buildStatus == 'UNSTABLE') {
		color = 'YELLOW'
		colorCode = '#FFFE89'
	} else {
		color = 'RED'
		colorCode = '#FF0000'
	}

	// Send notifications
	slackSend baseUrl: 'https://hooks.slack.com/services/', 
		channel: '#devopscasestudy', 
		color: colorCode, 
		message: summary, 
		teamDomain: 'devops-bootcamp-group', 
		tokenCredentialId: 'slack-devops'

	mail subject: subject,
		body: details,
		to: 'jeremiahjohn.roldan@sprint.com',
		from: 'do-not-reply@jenkins.com',
		replyTo: 'do-not-reply@jenkins.com'
		//recipientProviders: [[$class: 'DevelopersRecipientProvider']]
}

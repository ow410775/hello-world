node {
	def server = Artifactory.newServer url: 'http://127.0.0.1:8081/artifactory/', username: 'admin', password: 'Jijimon27'
	def rtMaven = Artifactory.newMavenBuild()
	def buildInfo
	def mvnHome
	def TESTER
	
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
		//rtMaven.deployer.artifactDeploymentPatterns.addInclude("*.*ar")
		buildInfo = Artifactory.newBuildInfo() // Publishing build-info to Artifactory
		//buildInfo.retention maxBuilds: 10, maxDays: 7, deleteBuildArtifacts: true
		buildInfo.env.capture = true
		TESTER = 'DevOps-GROUP4'
	}
	
	stage('Sonarqube Quality Gate') {
		def scannerHome = tool 'SonarQubeScanner';
		echo 'Initiating SonarQube test'
		withSonarQubeEnv('SonarQube') { 
			//sh "${scannerHome}/bin/sonar-scanner"
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
	
	stage ('Slack Notification') {
		slackSend baseUrl: 'https://hooks.slack.com/services/', 
		channel: '#devopscasestudy', 
		color: 'good', 
		message: 'Jenkins Pipeline - ${env.JOB_NAME} Started: Build ${env.BUILD_NUMBER}', 
		teamDomain: 'devops-bootcamp-group', 
		tokenCredentialId: 'slack-devops'
	}
}

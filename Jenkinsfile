node {
	def server = Artifactory.newServer url: 'http://127.0.0.1:8081/artifactory/', username: 'admin', password: 'Jijimon27'
	def rtMaven = Artifactory.newMavenBuild()
	def buildInfo
	def mvnHome
	def TESTER
	
	stage('Get Source') {
		git url: 'https://github.com/ow410775/hello-world.git'
		mvnHome = tool 'M3'
	}
	
	stage('---clean---') {
        	sh "mvn clean"
	}
	
	stage('--test--') {
		sh "mvn test"
	}
	
	stage ('Artifactory: Configuration') {
		rtMaven.tool = 'M3' // Tool name from Jenkins configuration
		rtMaven.deployer releaseRepo: 'libs-release-local', snapshotRepo: 'libs-snapshot-local', server: server
		//rtMaven.deployer.artifactDeploymentPatterns.addInclude("*.*ar")
		buildInfo = Artifactory.newBuildInfo() // Publishing build-info to Artifactory
		//buildInfo.retention maxBuilds: 10, maxDays: 7, deleteBuildArtifacts: true
		buildInfo.env.capture = true
		TESTER = 'placeholder'
	}
	
	stage('Sonarqube Analysis') {
		def scannerHome = tool 'SonarQubeScanner';
		echo 'Initiating SonarQube test'
		withSonarQubeEnv('SonarQube') { 
			sh "${scannerHome}/bin/sonar-scanner"
			sleep 10
			echo "The tester is ${TESTER}"
			sleep 20
			echo "This is build number ${BUILD_ID}"
			sh 'mvn sonar:sonar -Dsonar.projectKey=DevOps_CaseStudy -Dsonar.host.url=http://127.0.0.1:9000 -Dsonar.projectVersion=helloworld-1.0.0.${BUILD_NUMBER}-SNAPSHOT.war -Dlicense.skip=true'
		}
		echo 'SonarQube Test Complete'
		timeout(time: 10, unit: 'MINUTES') {
			waitForQualityGate abortPipeline: true
		}
	}
	
	//stage('Build') {
	//	withEnv(["MVN_HOME=$mvnHome"]) {
	//		sh '"$MVN_HOME/bin/mvn" -Dmaven.test.failure.ignore clean install -Dv=${BUILD_NUMBER} package'
	//	}
	//}
	
	stage ('Artifactory: Execute Maven Build') {
		rtMaven.run pom: 'pom.xml', goals: '-Dmaven.test.failure.ignore install -Dv=${BUILD_NUMBER} package', buildInfo: buildInfo
	}
	
	stage ('Artifactory: Publish Build Info and Upload') {
		//sh 'scp /var/lib/jenkins/.m2/repository/com/example/webapp/1.0.0.${BUILD_NUMBER}-SNAPSHOT/webapp-1.0.0.${BUILD_NUMBER}-SNAPSHOT.war [TARGET -- mrevita@172.31.18.118:/opt/sample-java-app/helloworld.war]'
		
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
}

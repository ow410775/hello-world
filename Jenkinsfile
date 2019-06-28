node {
	def server = Artifactory.newServer url: 'http://127.0.0.1:8081/artifactory/', username: 'admin', password: 'Jijimon27'
	def rtMaven = Artifactory.newMavenBuild()
	def buildInfo
	def mvnHome
	
	stage('Get Source') {
		git url: 'https://github.com/ow410775/hello-world.git'
		mvnHome = tool 'm3'
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
		buildInfo = Artifactory.newBuildInfo() // Publishing build-info to Artifactory
		//buildInfo.retention maxBuilds: 10, maxDays: 7, deleteBuildArtifacts: true
		buildInfo.env.capture = true
	}
	//stage('Build') {
	//	withEnv(["MVN_HOME=$mvnHome"]) {
	//		sh '"$MVN_HOME/bin/mvn" -Dmaven.test.failure.ignore clean install -Dv=${BUILD_NUMBER}'
	//	}
	//}
	stage ('Artifactory: Execute Maven') {
		rtMaven.run pom: 'pom.xml', goals: '-Dmaven.test.failure.ignore clean install -Dv=${BUILD_NUMBER} package', buildInfo: buildInfo
	}
	stage ('Artifactory: Publish Build Info') {
		server.publishBuildInfo buildInfo
	}
}

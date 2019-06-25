node {
	def server = Artifactory.newServer url: 'http://127.0.0.1:8081/artifactory/', credentialsId: 'admin.jfrog.localhost'
	def rtMaven = Artifactory.newMavenBuild()
	def buildInfo
	
	stage('---clean---') {
        	sh "mvn clean"
	}
	stage('--test--') {
		sh "mvn test"
	}
	stage ('artifactory: init') {
		rtMaven.tool = 'M3' // Tool name from Jenkins configuration
		rtMaven.deployer releaseRepo: 'libs-release-local', snapshotRepo: 'libs-snapshot-local', server: server
		buildInfo = Artifactory.newBuildInfo()
		buildInfo.env.capture = true
	}
	stage('Build') {
		withEnv(["MVN_HOME=$rtMaven.tool"]) {
			sh '"$MVN_HOME/bin/mvn" -Dmaven.test.failure.ignore clean install -Dv=${BUILD_NUMBER}'
		}
	}
	stage ('maven: upload') {
		rtMaven.run pom: 'pom.xml', goals: 'package', buildInfo: buildInfo
		sh 'mkdir -p pkg'
		sh 'mv target/demo.war pkg/demo.war'
	}
	stage ('artifactory: publish info') {
		server.publishBuildInfo buildInfo
	}
}

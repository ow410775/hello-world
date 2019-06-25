def server = Artifactory.newServer url: 'http://127.0.0.1:8081/artifactory/', credentialsId: 'admin.jfrog.localhost'
def rtMaven = Artifactory.newMavenBuild()
def buildInfo

pipeline {
    agent any
        
    stages {
        stage('---clean---') {
            steps {
                sh "mvn clean"
            }
        }
        stage('--test--') {
            steps {
                sh "mvn test"
            }
        }        
        stage ('artifactory: init') {
            rtMaven.tool = 'M3' // Tool name from Jenkins configuration
            rtMaven.deployer releaseRepo: 'libs-release-local', snapshotRepo: 'libs-snapshot-local', server: server
            buildInfo = Artifactory.newBuildInfo()
            buildInfo.env.capture = true
        }
        stage ('maven: build') {
            rtMaven.run pom: 'pom.xml', goals: 'package', buildInfo: buildInfo
            sh 'mkdir -p pkg'
            sh 'mv target/demo.war pkg/demo.war'
        }
        stage ('artifactory: publish info') {
            server.publishBuildInfo buildInfo
        }
    }
}

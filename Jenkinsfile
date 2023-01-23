pipeline {
    agent any
    tools {
        git 'Default'
    }
    environment {
        RELEASE_VERSION = ''
    }
    stages {        
        stage ('checkout'){
            steps{
                deleteDir()
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], browser: [$class: 'GithubWeb', repoUrl: 'https://github.com/LizAsraf/nodejs_application_hello_world'],
                extensions: [], userRemoteConfigs: [[credentialsId: 'gitlab-jenkins-8-11', url: 'git@github.com:LizAsraf/nodejs_application_hello_world.git']]])
                sh 'git fetch --all --tags'
            }
        }

        stage ('build and unit-test') {           
            steps {
                script{
                    timeout(5) {
                        sh """
                            docker build --tag app_node:latest --file Dockerfile .
                            docker run -d --network jenk_gitlab_net --name app app_node:latest
                        """
                    }
                    timeout(1) {
                        sh "bash unit-test.sh" 
                    }
                        
                }
            }
        }

        stage ('e2e test') {
            when {anyOf{
                    branch "main" ; branch pattern: "feature/.*", comparator: "REGEXP"
                }
            }            
            steps {                               
                echo "no need end to end test"
                sh "docker rm -f app"                    
            }
        }


        stage ('tag and publish') {
            when {
                branch "main"
            }
            steps {
               script{
                    L_TAG = sh (
                        script: "git tag -l  | sort -V | tail -n 1",
                        returnStdout: true
                        ).trim()   
                    echo "$L_TAG"
                    if (L_TAG == ''){
                        newtag="v1.0.0"
                        echo "the new tag is $newtag" 
                    }
                    else{
                        newtag = sh (script:"bash version_calculator.sh ${L_TAG}", returnStdout: true).trim()
                        echo "the new tag is $newtag"   
                    }
                    echo "login into ecr..."
                    sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 118341628787.dkr.ecr.us-east-1.amazonaws.com"
                    echo "taggging image"
                    sh "docker tag app_node:latest 118341628787.dkr.ecr.us-east-1.amazonaws.com/nodejs_hello_world:${newtag}"
                    echo "pushing..."
                    sh "docker push 118341628787.dkr.ecr.us-east-1.amazonaws.com/nodejs_hello_world:${newtag}"
                    sh "git tag -a ${newtag} -m 'my new version ${newtag}'"                    
                    sshagent(credentials: ['newjenkins']) {
                      sh "git push --tag"
                    }
                    RELEASE_VERSION = newtag
                }
            }
        }
        // need to change the image name in the app helm charts with the argo cd repository {{with credentials}}
        //need also to change the version in the helm chart

        stage ('Deploy') {
            when { branch "main" }
            steps {                   
                sh "sed -i '6 s/app_node:latest/118341628787.dkr.ecr.us-east-1.amazonaws.com/nodejs_hello_world:${RELEASE_VERSION}/' docker-compose.yml"          
                sshagent(credentials: ['ec77bf52-f9b7-4b19-8b77-566333319f83']) {
                    sh """
                        ssh ubuntu@35.175.118.229 "sed -i '6 s/app_node:latest/118341628787.dkr.ecr.us-east-1.amazonaws.com/nodejs_hello_world:${RELEASE_VERSION}/' docker-compose.yml; docker-compose up"
                    """
                }
            }
        }
    }
    post {
        always {
            script{
                sh 'git clean -if'
                cleanWs()
            }
        }
        success {
            script{
                echo "success"
            }
        }         
        failure {
            script{
                // emailext body: 'bla bla bla', subject: 'publish failure', to: 'liz161@gmail.com'
                echo "1..2.3 failure"
            }
        }
    }   
}
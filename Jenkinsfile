pipeline {
    agent any
    tools {
        git 'Default'
    }
    triggers {
        gitlab(triggerOnPush: true, triggerOnMergeRequest: true, branchFilterType: 'All')
    }
    environment {
        RELEASE_VERSION = ''
    }
    stages {        
        stage ('checkout'){
            steps{
                script{
                    deleteDir()
                    // checkout([$class: 'GitSCM', branches: [[name: '*/main']], \
                    // extensions: [], userRemoteConfigs: [[credentialsId: 'gitlab-jenkins-8-11', url: 'git@github.com:LizAsraf/nodejs_application_hello_world.git']]])
                    checkout([$class: 'GitSCM', branches: [[name: '*/main']], browser: [$class: 'GithubWeb', repoUrl: 'https://github.com/LizAsraf/nodejs_application_hello_world'],
                    extensions: [], userRemoteConfigs: [[credentialsId: 'gitlab-jenkins-8-11', url: 'git@github.com:LizAsraf/nodejs_application_hello_world.git']]])
                    sh 'git fetch --all --tags'
                } 
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
                script{                                
                    echo "no need end to end test"
                    sh """
                        docker rm -f app
                    """                    
                }
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
                        newtag="1.0.0"
                        echo "the new tag is $newtag" 
                    }
                    else{
                        newtag = sh (script:"bash version_calculator.sh ${L_TAG}", returnStdout: true).trim()
                        echo "the new tag is $newtag"   
                    }
                    echo "login into ecr..."
                    // sh "aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 644435390668.dkr.ecr.us-west-2.amazonaws.com"
                    echo "taggging image"
                    // sh "docker tag blogapp:latest 644435390668.dkr.ecr.us-west-2.amazonaws.com/blogapp:${newtag}"
                    echo "pushing..."
                    // sh "docker push 644435390668.dkr.ecr.us-west-2.amazonaws.com/blogapp:${newtag}"
                    sh "git tag -a v${newtag} -m 'my new version ${newtag}'"                    
                    withCredentials([sshUserPrivateKey(credentialsId: 'gitlab-jenkins-8-11', keyFileVariable: '')]) {
                        sh "git push --tag"
                    }
                    RELEASE_VERSION = newtag
                }
            }
        }
        // need to change the image name in the app helm charts with the argo cd repository {{with credentials}}
        //need also to change the version in the helm chart

        // stage ('Deploy') {
        //     when { branch "main" }
        //     steps {
        //         script{
        //             checkout([$class: 'GitSCM', branches: [[name: '*/main']], \
        //             extensions: [], userRemoteConfigs: [[credentialsId: 'gitlab-jenkins-8-11', url: 'git@gitlab.com:liz.asraf/argo-cd.git']]])                        
        //             sh """cd blogapp
        //             sed -i '11s/version: .*/version: ${RELEASE_VERSION}/g' Chart.yaml
        //             sed -i '11s/tag: .*/tag: "${RELEASE_VERSION}"/g' values.yaml
        //             git commit -am "version ${RELEASE_VERSION} updated"
        //             git push origin HEAD:main
        //             """           
        //         }
        //     }
        // }
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
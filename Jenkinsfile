pipeline {
    agent any
    tools{
        maven 'maven'
    }
    stages {
        
        stage('increament and detect the version') {
            steps {
                script {
                sh 'mvn build-helper:parse-version versions:set -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.newIncrementalVersion} versions:commit '      
               
              def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
              def version =  matcher[0][1]                  
              env.IMAGE_NAME = "$version" 
                }
            }
        }



        stage('bulild app in jenkins') {
            steps {
                sh 'mvn clean package  '
               
                sh 'mvn package'

            }
        }
          stage('build the image') {
            steps {
               sh " dcoker build -t mohamedbedier/javaapp:${IMAGE_NAME} ."
            }
        }
          stage('pushing container to rpeo') {
            steps {
                
              withCredentials( [ usernamePassword(credentialsId: 'docker-repo' , passwordVariable: 'PASS' , usernameVariable: 'USER' )] ) {
                       sh " docker login -u  $USER -p $PASS "
                         sh " docker push mohamedbedier/javaapp:${IMAGE_NAME} "
                        }
            
                                         
            }

        }
          stage('pushing version editing to github') {
            steps {
                 withCredentials( [ usernamePassword(credentialsId: 'git-repo' , passwordVariable: 'PASS' , usernameVariable: 'USER' )] ) {
                        sh  ' git status '
                        sh ' config  --global user.email "jenkins@example.com'
                        sh ' config  --global user.name "jenkins'

                        sh " git remote  set-url  origin https://${USER}:${PASS}@github.com/Bedier1/java-maven-cicd.git"                         
                        
                        sh 'git add .'
                        
                        sh ' git commit -m "ci integration" '
                        sh ' git push origin HEAD:master '
                        }


            }
        }
  
  
        
    }
}


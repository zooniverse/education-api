#!groovy

pipeline {
  agent none

  options {
    disableConcurrentBuilds()
  }

  stages {
    stage('Build Docker image') {
      agent any
      steps {
        script {
          def dockerRepoName = 'zooniverse/education-api'
          def dockerImageName = "${dockerRepoName}:${GIT_COMMIT}"
          def buildArgs = "--build-arg REVISION='${GIT_COMMIT}' ."
          def newImage = docker.build(dockerImageName, buildArgs)
          newImage.push()

          if (BRANCH_NAME == 'master') {
            stage('Update latest tag') {
              newImage.push('latest')
            }
          }
        }
      }
    }

    stage('Dry run deployments') {
      agent any
      steps {
        sh "kubectl --context azure apply --dry-run=client --record -f kubernetes/redis-staging.yaml"
        sh "sed 's/__IMAGE_TAG__/${GIT_COMMIT}/g' kubernetes/deployment-staging.tmpl | kubectl --context azure apply --dry-run=client --record -f -"
        sh "kubectl --context azure apply --dry-run=client --record -f kubernetes/redis-production.yaml"
        sh "sed 's/__IMAGE_TAG__/${GIT_COMMIT}/g' kubernetes/deployment-production.tmpl | kubectl --context azure apply --dry-run=client --record -f -"
      }
    }

    stage('Deploy staging to Kubernetes') {
      when { branch 'master' }
      agent any
      steps {
        sh "kubectl --context azure apply --record -f kubernetes/redis-staging.yaml"
        sh "sed 's/__IMAGE_TAG__/${GIT_COMMIT}/g' kubernetes/deployment-staging.tmpl | kubectl --context azure apply --record -f -"
      }
    }

    stage('Deploy production to Kubernetes') {
      when { tag 'production-release' }
      agent any
      steps {
        sh "kubectl --context azure apply --record -f kubernetes/redis-production.yaml"
        sh "sed 's/__IMAGE_TAG__/${GIT_COMMIT}/g' kubernetes/deployment-production.tmpl | kubectl --context azure apply --record -f -"
      }
    }
  }
}

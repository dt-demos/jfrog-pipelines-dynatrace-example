#!/bin/bash

# this script is used to send a Dynatrace push event
# assumes three tags (project, service, stage) exist for the tag matching rule
# reference: https://www.dynatrace.com/support/help/dynatrace-api/environment-api/events/post-event/

DT_BASEURL=$1
DT_API_TOKEN=$2
DEPLOYMENT_PROJECT=$3
DEPLOYMENT_VERSION=$4
CI_BACK_LINK=$5
SOURCE=$6
IMAGE_NAME=$7
HELM_CHART=$8
JFROG_USER=$9
JFROG_ARTIFACTORY_URL=${10}
PIPELINE_REPO=${11}
JFROG_PIPELINE_NAME=${12}
JFROG_RUN_NUMBER=${13}
JFROG_PROJECT=${14}
TAG_RULE="${15}"

DT_TAG_PROJECT=$DT_TAG_PROJECT
DT_API_URL="$DT_BASEURL/api/v1/events"
DEPLOYMENT_NAME="Set $DEPLOYMENT_PROJECT to version $DEPLOYMENT_VERSION"

echo "================================================================="
echo "Sending Dynatrace Deployment event"
echo "DT_API_URL          = $DT_API_URL"
echo "DEPLOYMENT_NAME     = $DEPLOYMENT_NAME"
echo "DEPLOYMENT_VERSION  = $DEPLOYMENT_VERSION"
echo "CI_BACK_LINK        = $CI_BACK_LINK"
echo "SOURCE              = $SOURCE"
echo "IMAGE_NAME          = $IMAGE_NAME"
echo "HELM_CHART          = $HELM_CHART"
echo "JFROG_USER          = $JFROG_USER"
echo "JFROG_ARTIFACTORY_URL=$JFROG_ARTIFACTORY_URL"
echo "PIPELINE_REPO       = $PIPELINE_REPO"
echo "JFROG_PIPELINE_NAME = $JFROG_PIPELINE_NAME"
echo "JFROG_RUN_NUMBER    = $JFROG_RUN_NUMBER"
echo "JFROG_PROJECT       = $JFROG_PROJECT"
echo "TAG_RULE            = $TAG_RULE"
echo "================================================================="
POST_DATA=$(cat <<EOF
  {
      "eventType" : "CUSTOM_DEPLOYMENT",
      "source" : "$SOURCE" ,
      "deploymentName" : "$DEPLOYMENT_NAME",
      "deploymentVersion" : "$DEPLOYMENT_VERSION",
      "deploymentProject" : "$JFROG_PROJECT" ,
      "ciBackLink" : "$CI_BACK_LINK",
      "customProperties": {
          "JFrog User" : "$JFROG_USER",
          "JFrog Artifactory URL" : "$JFROG_ARTIFACTORY_URL",
          "JFrog Project" : "$JFROG_PROJECT",
          "JFrog Pipeline Name" : "$JFROG_PIPELINE_NAME",
          "JFrog Run Number" : "$JFROG_RUN_NUMBER",
          "JFrog Pipeline Repo" : "$PIPELINE_REPO",
          "Image Name" : "$IMAGE_NAME",
          "Helm Chart" : "$HELM_CHART"
      },
      "attachRules" : {
            "tagRule" : ${TAG_RULE}
        }
  }
EOF
)

echo "Push Event POST_DATA"
echo $POST_DATA
echo ""
echo "Response Data"
curl --url "$DT_API_URL" -H "Content-type: application/json" -H "Authorization: Api-Token "$DT_API_TOKEN -X POST -d "$POST_DATA"

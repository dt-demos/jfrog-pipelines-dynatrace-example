#!/bin/bash

# this script is used to send a Dynatrace push event
# assumes three tags (project, service, stage) exist for the tag matching rule
# reference: https://www.dynatrace.com/support/help/dynatrace-api/environment-api/events/post-event/

DT_BASEURL=$1
DT_API_TOKEN=$2
DT_TAG_PROJECT=$3
DT_TAG_STAGE=$4
DT_TAG_SERVICE=$5
DEPLOYMENT_VERSION=$6
CI_BACK_LINK=$7
SOURCE=$8

DT_TAG_PROJECT=$DT_TAG_PROJECT
DT_API_URL="$DT_BASEURL/api/v1/events"
DEPLOYMENT_NAME="Set $DT_TAG_SERVICE to version $DEPLOYMENT_VERSION"

echo "================================================================="
echo "Sending Dynatrace Deployment event"
echo "DT_API_URL          = $DT_API_URL"
echo "DEPLOYMENT_NAME     = $DEPLOYMENT_NAME"
echo "DEPLOYMENT_VERSION  = $DEPLOYMENT_VERSION"
echo "DT_TAG_PROJECT      = $DT_TAG_PROJECT"
echo "DT_TAG_SERVICE      = $DT_TAG_SERVICE"
echo "DT_TAG_STAGE        = $DT_TAG_STAGE"
echo "CI_BACK_LINK        = $CI_BACK_LINK"
echo "SOURCE              = $SOURCE"
echo "================================================================="
POST_DATA=$(cat <<EOF
  {
      "eventType" : "CUSTOM_DEPLOYMENT",
      "source" : "$SOURCE" ,
      "deploymentName" : "$DEPLOYMENT_NAME",
      "deploymentVersion" : "$DEPLOYMENT_VERSION"  ,
      "deploymentProject" : "$DT_TAG_PROJECT" ,
      "ciBackLink" : "$CI_BACK_LINK",
      "customProperties": {
          "Example Custom Property 1" : "Example Custom Value 1",
          "Example Custom Property 2" : "Example Custom Value 2",
          "Example Custom Property 3" : "Example Custom Value 3"
      },
      "attachRules" : {
            "tagRule" : [
                {
                  "meTypes":["PROCESS_GROUP_INSTANCE"],
                  "tags": [
                      {
                            "context": "CONTEXTLESS",
                            "key": "service",
                              "value": "$DT_TAG_SERVICE"
                      },
                          {
                            "context": "CONTEXTLESS",
                            "key": "project",
                              "value": "$DT_TAG_PROJECT"
                      },
                          {
                            "context": "CONTEXTLESS",
                            "key": "stage",
                              "value": "$DT_TAG_STAGE"
                      }
            ]}
          ]}
        }
  }
EOF
)

echo "Push Event POST_DATA"
echo $POST_DATA
echo ""
echo "Response Data"
curl --url "$DT_API_URL" -H "Content-type: application/json" -H "Authorization: Api-Token "$DT_API_TOKEN -X POST -d "$POST_DATA"

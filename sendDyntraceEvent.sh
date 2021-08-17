#!/bin/bash

# reference: https://www.dynatrace.com/support/help/dynatrace-api/environment-api/events/post-event/
# example arguments: dt-orders dev order-service 1 http://mycd-tool.com
DEPLOYMENT_PROJECT=$1
TAG_STAGE=$2
TAG_SERVICE=$3
DEPLOYMENT_VERSION=$4
CI_BACK_LINK=$5
SOURCE=$6

TAG_PROJECT=$DEPLOYMENT_PROJECT
DT_API_URL="$DT_BASEURL/api/v1/events"
DEPLOYMENT_NAME="Set $TAG_SERVICE to version $DEPLOYMENT_VERSION"

echo "================================================================="
echo "Sending Dynatrace Deployment event"
echo "DT_API_URL                 = $DT_API_URL"
echo "DEPLOYMENT_NAME            = $DEPLOYMENT_NAME"
echo "DEPLOYMENT_VERSION         = $DEPLOYMENT_VERSION"
echo "DEPLOYMENT_PROJECT         = $DEPLOYMENT_PROJECT"
echo "CI_BACK_LINK               = $CI_BACK_LINK"
echo "================================================================="
POST_DATA=$(cat <<EOF
  {
      "eventType" : "CUSTOM_DEPLOYMENT",
      "source" : "$SOURCE" ,
      "deploymentName" : "$DEPLOYMENT_NAME",
      "deploymentVersion" : "$DEPLOYMENT_VERSION"  ,
      "deploymentProject" : "$DEPLOYMENT_PROJECT" ,
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
                              "value": "$TAG_SERVICE"
                      },
                          {
                            "context": "CONTEXTLESS",
                            "key": "project",
                              "value": "$TAG_PROJECT"
                      },
                          {
                            "context": "CONTEXTLESS",
                            "key": "stage",
                              "value": "$TAG_STAGE"
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

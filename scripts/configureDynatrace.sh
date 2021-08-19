#!/bin/bash

# this script is used to configure Dynatrace
# assumes three tags (project, service, stage) exist for the tag matching rule

DT_BASEURL=$1
DT_API_TOKEN=$2
DT_TAG_PROJECT=$3
DT_TAG_STAGE=$4
DT_TAG_SERVICE=$5

echo "================================================================="
echo "Confugure Dynatrace"
echo "DT_BASEURL          = $DT_BASEURL"
echo "DT_TAG_PROJECT      = $DT_TAG_PROJECT"
echo "DT_TAG_SERVICE      = $DT_TAG_SERVICE"
echo "DT_TAG_STAGE        = $DT_TAG_STAGE"
echo "================================================================="

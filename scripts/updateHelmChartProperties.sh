#!/bin/bash

# this script is used to add/update these chart properties by calling the JFrog API
# deployedOnCluster
# deploymentTimestamp

JFROG_BASE_URL=$1
JFROG_API_KEY=$2
CHART_REPO=$3
CHART=$4
CLUSTER=$5

TIME=$(date +%s)
JFROG_CHART_URL=${JFROG_BASE_URL}/artifactory/api/storage/${CHART_REPO}/${CHART}.tgz
JFROG_FULL_URL=${JFROG_CHART_URL}?properties=deployedOnCluster=${CLUSTER}%7CdeploymentTimestamp=${TIME}

echo "================================================================="
echo "Updating Helm Chart Properties"
echo "JFROG_BASE_URL  = $JFROG_BASE_URL"
echo "CHART_REPO      = $CHART_REPO "
echo "CHART           = $CHART"
echo "CLUSTER         = $CLUSTER"
echo "JFROG_FULL_URL  = $JFROG_FULL_URL"
echo "================================================================="

curl --write-out "Request response code: %{http_code}\n" --silent --location --request PUT ${JFROG_FULL_URL} --header "Accept:application/json" --header "X-Jfrog-Art-Api:${JFROG_API_KEY}"

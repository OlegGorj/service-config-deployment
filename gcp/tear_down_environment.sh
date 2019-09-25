#!/bin/bash
# Tear down non-prod Kubernetes cluster on GKE with Istio

[[ -f $1 ]] || printf "File not found! Please provide valid configuration file." || exit 1

readonly PROJECT=$(jq '.gcp.project' ${1} | tr -d '"' )
readonly CLUSTER=$(jq '.gcp.cluster' ${1} | tr -d '"' )
readonly REGION=$(jq '.gcp.region' ${1} | tr -d '"' )
readonly MASTER_AUTH_NETS=$(jq '.gcp.nets' ${1} | tr -d '"' )
readonly NAMESPACES=( 'dev' 'test' 'uat' )

gcloud config set project $PROJECT

# Delete GKE cluster (time in foreground)
time yes | gcloud beta container clusters delete $CLUSTER --region $REGION

# Confirm network resources are also deleted
gcloud compute forwarding-rules list
gcloud compute target-pools list
gcloud compute firewall-rules list

# In case target-pool associated with Cluster is not deleted
yes | gcloud compute target-pools delete  \
  $(gcloud compute target-pools list \
    --filter="region:($REGION)" --project $PROJECT \
  | awk 'NR==2 {print $1}')

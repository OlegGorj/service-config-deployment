#!/bin/bash
# Tear down non-prod Kubernetes cluster on GKE with Istio

[[ -f $1 ]] || printf "File not found! Please provide valid configuration file." || exit 1

JSONCONFIG=$(cat $1)

#
# delete k8s cluster
#
function destroy_cluster() {
  PROJECT=$1
  CLUSTER=$2
  REGION=$3
  ZONE=$4
  MASTER_AUTH_NETS=$5
  K8S_VER=$6
  MACHINE_TYPE=$7

  NAMESPACES=( 'dev' 'test' 'uat' )

  gcloud config set project $PROJECT

  # Delete GKE cluster (time in foreground)
  time yes | gcloud beta container clusters delete $CLUSTER --zone $ZONE

  # Confirm network resources are also deleted
  gcloud compute forwarding-rules list
  gcloud compute target-pools list
  gcloud compute firewall-rules list

  # In case target-pool associated with Cluster is not deleted
  yes | gcloud compute forwarding-rules delete --region=$REGION  \
    $(gcloud compute forwarding-rules list \
      --filter="region:($REGION)" --project $PROJECT \
    | awk 'NR==2 {print $1}')

  # In case target-pool associated with Cluster is not deleted
  yes | gcloud compute target-pools delete --region=$REGION  \
    $(gcloud compute target-pools list \
      --filter="region:($REGION)" --project $PROJECT \
    | awk 'NR==2 {print $1}')

}

CONFIGSLIST=$(jq '.gcp[] | .cluster' <<< "$JSONCONFIG" | tr -d '"')
for k in $CONFIGSLIST; do
    echo "zone for cluster $k is " $(jq -r --arg kluster "$k" '.gcp[] | select(.cluster == $kluster) | .zone' <<< "$JSONCONFIG" )
    destroy_cluster \
        $(jq -r --arg kluster "$k" '.gcp[] | select(.cluster == $kluster) | .project' <<< "$JSONCONFIG" ) \
        $k \
        $(jq -r --arg kluster "$k" '.gcp[] | select(.cluster == $kluster) | .region' <<< "$JSONCONFIG" ) \
        $(jq -r --arg kluster "$k" '.gcp[] | select(.cluster == $kluster) | .zone' <<< "$JSONCONFIG" ) \
        $(jq -r --arg kluster "$k" '.gcp[] | select(.cluster == $kluster) | .nets' <<< "$JSONCONFIG" ) \
        $(jq -r --arg kluster "$k" '.gcp[] | select(.cluster == $kluster) | .k8s_version' <<< "$JSONCONFIG" ) \
        $(jq -r --arg kluster "$k" '.gcp[] | select(.cluster == $kluster) | .machine_type' <<< "$JSONCONFIG" )
done

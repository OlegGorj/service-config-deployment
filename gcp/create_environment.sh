#!/bin/bash
# Create non-prod Kubernetes cluster on GKE with Istio

[[ -f $1 ]] || printf "File not found! Please provide valid configuration file." || exit 1

JSONCONFIG=$(cat $1)

#
# function to deploy gcp k8s cluster
#
function deploy_cluster() {

  PROJECT=$1
  CLUSTER=$2
  REGION=$3
  ZONE=$4
  MASTER_AUTH_NETS=$5
  K8S_VER=$6
  MACHINE_TYPE=$7

  NAMESPACES=( 'dev' 'test' 'uat' )

  gcloud config set project $PROJECT

  # Build a 3-node, single-region, multi-zone GKE cluster
  time gcloud beta container \
    --project $PROJECT clusters create $CLUSTER \
    --zone $ZONE \
    --no-enable-basic-auth \
    --no-issue-client-certificate \
    --cluster-version $K8S_VER \
    --machine-type $MACHINE_TYPE \
    --image-type "COS" \
    --disk-type "pd-standard" \
    --disk-size "100" \
    --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
    --num-nodes "1" \
    --enable-stackdriver-kubernetes \
    --enable-ip-alias \
    --network "projects/${PROJECT}/global/networks/default" \
    --subnetwork "projects/${PROJECT}/regions/${REGION}/subnetworks/default" \
    --default-max-pods-per-node "110" \
    --addons HorizontalPodAutoscaling,HttpLoadBalancing,Istio \
    --istio-config auth=MTLS_STRICT \
    --metadata disable-legacy-endpoints=true \
    --enable-autoupgrade \
    --enable-autorepair

  # Get cluster credentials
  gcloud container clusters get-credentials $CLUSTER --zone $ZONE --project $PROJECT

  kubectl config current-context

  # Create Namespaces
  kubectl apply -f ./resources/namespaces.yaml

  # Enable automatic Istio sidecar injection
  for namespace in ${NAMESPACES[@]}; do
    kubectl label namespace $namespace istio-injection=enabled --overwrite
  done

  # kubectl label namespace dev istio-injection=disabled --overwrite
}

CONFIGSLIST=$(jq '.gcp[] | .cluster' <<< "$JSONCONFIG" | tr -d '"')
for k in $CONFIGSLIST; do
    echo "zone for cluster $k is " $(jq -r --arg kluster "$k" '.gcp[] | select(.cluster == $kluster) | .zone' <<< "$JSONCONFIG" )
    deploy_cluster \
        $(jq -r --arg kluster "$k" '.gcp[] | select(.cluster == $kluster) | .project' <<< "$JSONCONFIG" ) \
        $k \
        $(jq -r --arg kluster "$k" '.gcp[] | select(.cluster == $kluster) | .region' <<< "$JSONCONFIG" ) \
        $(jq -r --arg kluster "$k" '.gcp[] | select(.cluster == $kluster) | .zone' <<< "$JSONCONFIG" ) \
        $(jq -r --arg kluster "$k" '.gcp[] | select(.cluster == $kluster) | .nets' <<< "$JSONCONFIG" ) \
        $(jq -r --arg kluster "$k" '.gcp[] | select(.cluster == $kluster) | .k8s_version' <<< "$JSONCONFIG" ) \
        $(jq -r --arg kluster "$k" '.gcp[] | select(.cluster == $kluster) | .machine_type' <<< "$JSONCONFIG" )
done

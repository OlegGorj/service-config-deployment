# Deployment of service to manage configuration data

[![GitHub release](https://img.shields.io/github/release/OlegGorj/service-config-deployment.svg)](https://github.com/OlegGorj/service-config-deployment/releases)
[![GitHub issues](https://img.shields.io/github/issues/OlegGorj/service-config-deployment.svg)](https://github.com/OlegGorj/service-config-deployment/issues)
[![GitHub commits](https://img.shields.io/github/commits-since/OlegGorj/service-config-deployment/0.0.1.svg)](https://github.com/OlegGorj/service-config-deployment)


## How to deploy Config Service on GCP

### Create config file

Configuration file aims to list and describe Kubernetes clusters we're about to create. The following is an example of such configuration file:

```
{
  "gcp": [
    {
      "project": "my_gcp_project",
      "cluster": "standard-cluster-1",
      "region": "us-east1",
      "zone": "us-east1-b",
      "nets": "72.231.208.0/24",
      "k8s_version": "1.13.7-gke.8",
      "machine_type": "n1-standard-1",
      "size": "3"
    },
    {
      "project": "my_gcp_project",
      "cluster": "standard-cluster-2",
      "region": "us-west1",
      "zone": "us-west1-a",
      "nets": "72.231.208.0/24",
      "k8s_version": "1.13.7-gke.8",
      "machine_type": "n1-standard-2",
      "size": "3"
    }

  ]

}
```

What this configuration says:
 - deploy 2 k8s clusters on GCP
 - both clusters on GCP project `my_gcp_project`
 - names of the clusters `standard-cluster-1` and `standard-cluster-2` respectively
 - deploy cluster `standard-cluster-1` in zone `us-east1-b` and cluster `standard-cluster-2` in zone `us-west1-a`
 - the rest is fairly self explanatory

### Ask for JWT token

```
TOKEN=$(curl --request POST   --url https://<auth0-your-tenat>.auth0.com/oauth/token   --header 'content-type: application/json'   --data '{"client_id":"<client id>","client_secret":"<the_secret>","audience":"https://api.<your domain name>","grant_type":"client_credentials"}' | jq '.access_token' | tr -d '"')
```

### Call the service using the token

```
curl --header "Authorization: Bearer $TOKEN" http://dev.api.<your domain name>/api/v2/configmaps/sandbox/0?out=json
```





---

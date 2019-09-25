# Deployment of service to manage configuration data

[![GitHub release](https://img.shields.io/github/release/OlegGorj/service-config-deployment.svg)](https://github.com/OlegGorj/service-config-deployment/releases)
[![GitHub issues](https://img.shields.io/github/issues/OlegGorj/service-config-deployment.svg)](https://github.com/OlegGorj/service-config-deployment/issues)
[![GitHub commits](https://img.shields.io/github/commits-since/OlegGorj/service-config-deployment/0.0.1.svg)](https://github.com/OlegGorj/service-config-deployment)


The `service-config-deployment` repo designated to host code and instructions for deploying Configuration Data Service `service-config-data` (https://github.com/OlegGorj/service-config-data) on various Cloud platforms.
It also designed to host creation and managmnent of multiple environments (`dev`, `stg`, `prod`, etc) along with security aspects.


---

## Directory structure

This is how complete directory structure should look like after installing all repos and resolving dependancies.

```
├── LICENSE
├── README.md
└── gcp
    ├── config-cloud.json
    ├── create_environment.sh
    ├── resources
    │   ├── auth-policy-dev.yaml
    │   ├── auth-policy-test.yaml
    │   ├── auth-policy-uat.yaml
    │   ├── istio-gateway.yaml
    │   └── namespaces.yaml
    └── tear_down_environment.sh
```
---

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
      "machine_type": "n1-standard-1"
    },
    {
      "project": "my_gcp_project",
      "cluster": "standard-cluster-2",
      "region": "us-west1",
      "zone": "us-west1-a",
      "nets": "72.231.208.0/24",
      "k8s_version": "1.13.7-gke.8",
      "machine_type": "n1-standard-2"
    }

  ]

}

```

What this configuration says is:
 - deploy 2 k8s clusters on GCP
 - both part of GCP project `my_gcp_project`
 - names of the clusters `standard-cluster-1` and `standard-cluster-2` receptively
 - deploy cluster `standard-cluster-1` in zone `us-east1-b` and cluster `standard-cluster-2` in zone `us-west1-a`
 - the rest is fairly self explanatory



---

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

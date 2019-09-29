#!/bin/bash
#
readonly CERT_PATH=~/Downloads/sslforfree_wildcard

readonly NAMESPACES=( 'dev' 'test' 'uat' )


kubectl create -n istio-system secret tls istio-ingressgateway-certs --key $CERT_PATH/private.key --cert $CERT_PATH/certificate.crt

  # Istio Gateway and three ServiceEntry resources
  kubectl apply -f ./resources/istio-gateway.yaml

  # End-user auth applied per environment
  kubectl apply -f ./resources/other/auth-policy-dev.yaml
  kubectl apply -f ./resources/other/auth-policy-test.yaml
  kubectl apply -f ./resources/other/auth-policy-uat.yaml

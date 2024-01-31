#!/bin/bash
echo "minimum-values"
timoni -n test build keycloak  ../ --values ../values.cue --values ../samples/minimum/minimum-values.cue > ./minimum.yaml
echo "ingress-pvc-values"
timoni -n test build keycloak  ../ --values ../values.cue --values ../samples/minimum/ingress-pvc-values.cue > ./ingress-pvc.yaml
echo "pvc-values"
timoni -n test build keycloak  ../ --values ../values.cue --values ./pvc-values.cue > ./pvc.yaml
echo "http-values"
timoni -n zel-test  build keycloak  ../ --values ../values.cue --values ./http-values.cue > ./http.yaml
echo "sa-values"
timoni -n test build keycloak  ../ --values ../values.cue --values ./sa-values.cue > ./sa.yaml
echo "certificate-values"
timoni -n test  build keycloak  ../ --values ../values.cue --values ./certificate-values.cue > ./certificate.yaml
echo "external-secrets-values"
timoni -n test build keycloak  ../ --values ../values.cue --values ./external-secrets-values.cue > ./external-secrets.yaml
echo "pdb-values"
timoni -n test build keycloak  ../ --values ../values.cue --values ./pdb-values.cue > ./pdb.yaml
echo "network-policy-values"
timoni -n test build keycloak  ../ --values ../values.cue --values ./networkpolicy-values.cue > ./networkpolicy.yaml
echo "ingress-values"
timoni -n zel-test build keycloak  ../ --values ../values.cue --values ./ingress-values.cue > ./ingress.yaml
echo "virtual-service-values"
timoni -n zel-test build keycloak  ../ --values ../values.cue --values ./virtualservice-values.cue > ./virtualservice.yaml
echo "production-istio-values"
timoni -n zel-test build keycloak  ../ --values ../values.cue --values ../samples/ha/postgres-istio-values.cue > ./postgres-istio.yaml

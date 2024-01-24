#!/bin/bash
echo "minimum-values"
timoni -n test build keycloak  ../ --values ../values.cue --values ./minimum-values.cue > ./minimum.yaml
echo "http-values"
timoni -n test build keycloak  ../ --values ../values.cue --values ./http-values.cue > ./http.yaml
echo "sa-values"
timoni -n test build keycloak  ../ --values ../values.cue --values ./sa-values.cue > ./sa.yaml
echo "certificate-values"
timoni -n test build keycloak  ../ --values ../values.cue --values ./certificate-values.cue > ./certificate.yaml
echo "external-secrets-values"
timoni -n test build keycloak  ../ --values ../values.cue --values ./external-secrets-values.cue > ./external-secrets.yaml
echo "pdb-values"
timoni -n test build keycloak  ../ --values ../values.cue --values ./pdb-values.cue > ./pdb.yaml
echo "network-policy-values"
timoni -n test build keycloak  ../ --values ../values.cue --values ./networkpolicy-values.cue > ./networkpolicy.yaml

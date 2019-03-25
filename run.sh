#!/bin/bash

export TF_CREDS=./creds/serviceaccount.json
export GOOGLE_APPLICATION_CREDENTIALS=${TF_CREDS}


kubectl create clusterrolebinding cluster-admin-binding \
    --clusterrole cluster-admin --user "$(gcloud config get-value account)"

kubectl create -f https://raw.githubusercontent.com/GoogleCloudPlatform/k8s-stackdriver/master/custom-metrics-stackdriver-adapter/deploy/production/adapter.yaml

kubectl create secret generic pubsub-key --from-file=key.json=pubsub.json

kubectl apply -f  pubsub-hpa.yaml
kubectl apply -f  pubsub-deployment.yaml

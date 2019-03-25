# HorizontalPodAutoscaler on Google Kubernetes Engine with external metrics from PubSub

https://cloud.google.com/kubernetes-engine/docs/tutorials/authenticating-to-cloud-platform

# provision GKE and PubSub with terraform
fetch your service account that can create all the necessary GCP resources
```
export TF_CREDS=./creds/serviceaccount.json
export GOOGLE_APPLICATION_CREDENTIALS=${TF_CREDS}

terraform init
terraform plan

echo yes | terraform apply
```

# deploy controller and example app on GKE

```
kubectl create clusterrolebinding cluster-admin-binding \
    --clusterrole cluster-admin --user "$(gcloud config get-value account)"

kubectl create -f https://raw.githubusercontent.com/GoogleCloudPlatform/k8s-stackdriver/master/custom-metrics-stackdriver-adapter/deploy/production/adapter.yaml

kubectl create secret generic pubsub-key --from-file=key.json=pubsub.json

kubectl apply -f  pubsub-hpa.yaml
kubectl apply -f  pubsub-deployment.yaml
```

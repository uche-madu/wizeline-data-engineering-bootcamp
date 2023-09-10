#!/bin/bash

# Retrieve the project ID
export PROJECT_ID=$(gcloud config get-value project)

# Create GCS bucket with uniform access control
gsutil mb -l us -b on gs://deb-capstone

# Create a Service Account
gcloud iam service-accounts create deb-sa \
    --display-name="DEB SA" \
    --description="Service Account for Wizeline Data Engineering Bootcamp"

# Generate and Download JSON Key
gcloud iam service-accounts keys create .credentials.json \
    --iam-account="deb-sa@${PROJECT_ID}.iam.gserviceaccount.com"

# Set the Service Account Key File Environment Variable
export GOOGLE_APPLICATION_CREDENTIALS=./.credentials.json

# Create specific IAM Role bindings following the principle of least priviledge

# Kubernetes Engine Role Binding:
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:deb-sa@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/container.admin"

# Cloud Storage Role Binding
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:deb-sa@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/storage.admin"

# Dataproc Role Binding
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:deb-sa@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/dataproc.editor"

# Storage viewer Role Binding
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:deb-sa@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/storage.objectViewer"

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:deb-sa@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/iam.serviceAccountTokenCreator"

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:deb-sa@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/serviceusage.serviceUsageConsumer"

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:deb-sa@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/compute.networkAdmin"

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:deb-sa@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/iam.serviceAccountAdmin"

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:deb-sa@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/serviceusage.serviceUsageAdmin"

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:deb-sa@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/iam.serviceAccountUser"


# Enable necessary APIs for GKE, Google Cloud Storage, and Dataproc
gcloud services enable container.googleapis.com \
    storage-component.googleapis.com \
    dataproc.googleapis.com



# gcloud beta container clusters create "cluster-1" \
#     --zone "us-central1-c" \
#     --no-enable-basic-auth \
#     --cluster-version "1.27.3-gke.100" \
#     --release-channel "regular" \
#     --machine-type "e2-medium" \
#     --image-type "COS_CONTAINERD" \
#     --disk-type "pd-balanced" \
#     --disk-size "100" \
#     --metadata disable-legacy-endpoints=true \
#     --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
#     --num-nodes "3" \
#     --logging=SYSTEM,WORKLOAD \
#     --monitoring=SYSTEM \
#     --enable-ip-alias \
#     --network "projects/wizeline-deb/global/networks/default" \
#     --subnetwork "projects/wizeline-deb/regions/us-central1/subnetworks/default" \
#     --no-enable-intra-node-visibility \
#     --default-max-pods-per-node "110" \
#     --security-posture=standard \
#     --workload-vulnerability-scanning=disabled \
#     --no-enable-master-authorized-networks \
#     --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver \
#     --enable-autoupgrade \
#     --enable-autorepair \
#     --max-surge-upgrade 1 \
#     --max-unavailable-upgrade 0 \
#     --binauthz-evaluation-mode​=DISABLED \
#     --enable-managed-prometheus \
#     --enable-shielded-nodes \
#     --node-locations "us-central1-c"
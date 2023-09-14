#!/bin/bash

# Retrieve the project ID
export PROJECT_ID=$(gcloud config get-value project)

export BUCKET_NAME="gs://deb-capstone"
# Check and create the GCS bucket with uniform access control if it doesn't exist
gsutil ls $BUCKET_NAME &> /dev/null || gsutil mb -l us -b on $BUCKET_NAME

# Create a Service Account
gcloud iam service-accounts create deb-sa \
    --display-name="DEB SA" \
    --description="Service Account for Wizeline Data Engineering Bootcamp"

# Generate and Download JSON Key
gcloud iam service-accounts keys create credentials.json \
    --iam-account="deb-sa@${PROJECT_ID}.iam.gserviceaccount.com"

# Set the Service Account Key File Environment Variable
# export GOOGLE_APPLICATION_CREDENTIALS=./.credentials.json

# Create specific IAM Role bindings following the principle of least privilege

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

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:deb-sa@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/iam.securityAdmin"

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:deb-sa@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/secretmanager.admin"

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:deb-sa@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/cloudsql.admin"


# Enable necessary APIs for GKE, Google Cloud Storage, and Dataproc
gcloud services enable container.googleapis.com \
    storage-component.googleapis.com \
    dataproc.googleapis.com
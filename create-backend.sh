#! /bin/bash -e
################################
##### Author: Andrew Milam #####
################################

######################################
##### Verifies Tool Installation #####
######################################
which jq 2>&1 >/dev/null || (echo "Error, jq executable is required" && exit 1) || exit 1
which terraform 2>&1 >/dev/null || (echo "Error, terraform executable is required" && exit 1) || exit 1
which gcloud 2>&1 >/dev/null || (echo "Error, gcloud executable is required" && exit 1) || exit 1


#####################################
##### Sets GCP Project Variable #####
#####################################
echo ""
export PROJECT="$(gcloud config get-value project)"
echo "Your current configured gcloud project is $PROJECT"
echo ""




##################################################
##### Service Account Creation For Terraform #####
##################################################
SA_NAME="${PROJECT:0:15}-tf"
GCP_USER=$(gcloud config get-value account)

if [[ -z $(gcloud iam service-accounts list|grep $SA_NAME) ]]
then
    gcloud iam service-accounts create $SA_NAME
fi

gcloud projects add-iam-policy-binding $PROJECT --member="user:${GCP_USER}" --role="roles/owner"
gcloud projects add-iam-policy-binding $PROJECT --member="user:${GCP_USER}" --role="roles/iam.serviceAccountTokenCreator"
gcloud projects add-iam-policy-binding $PROJECT --member="serviceAccount:${SA_NAME}@${PROJECT}.iam.gserviceaccount.com" --role="roles/owner"
gcloud projects add-iam-policy-binding $PROJECT --member="serviceAccount:${SA_NAME}@${PROJECT}.iam.gserviceaccount.com" --role="roles/storage.admin"
gcloud projects add-iam-policy-binding $PROJECT --member="serviceAccount:${SA_NAME}@${PROJECT}.iam.gserviceaccount.com" --role="roles/storage.objectAdmin"
gcloud iam service-accounts keys create ./"account.json" --iam-account "${SA_NAME}@${PROJECT}.iam.gserviceaccount.com"


###############################################
##### Sets Google Application Credentials #####
###############################################

export GOOGLE_APPLICATION_CREDENTIALS="account.json"

##################################################
##### Terraform Remote State Bucket Creation #####
##################################################
echo "
terraform {
  backend "\"gcs\""{
    bucket      = "\"${PROJECT}-cian-website-tfstate\""
    prefix      = "\"portfolio\""
    credentials = "\"account.json\""
  }
}
" > backend.tf

if [[ -z $(gsutil ls|grep ${PROJECT}-cian-website-tfstate) ]]
then
    gsutil mb gs://${PROJECT}-cian-website-tfstate
fi
terraform fmt --recursive
echo "Your remote state bucket is ${PROJECT}-cian-website-tfstate"

#! /bin/bash

read -p 'Enter a version number ' V
gcloud builds submit --tag "gcr.io/${DEVSHELL_PROJECT_ID}/website:${V}" .

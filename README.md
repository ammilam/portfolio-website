# portfolio-website

This project serves two functions...
- Standup a containerized serverless personal digital resume/portfolio website
- Demonstrate GCP native gitops through cloud build & github


## Setup

- create a GCP project
- follow the following [documentation](https://cloud.google.com/build/docs/access-private-github-repos) to link GCP to github
- git clone down the repo
- cd into the directory and execute the following:

```
# creates terraform gcs backend
./create-backend.sh
terraform init
terraform apply
```

***Note: you will be prompted for GCP Project ID, github repo, and repo owner.***
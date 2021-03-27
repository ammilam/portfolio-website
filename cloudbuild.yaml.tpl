 steps:
 # Build the container image
 - name: 'gcr.io/cloud-builders/docker'
   args: ['build','-t', 'gcr.io/$PROJECT_ID/portfolio-website:$COMMIT_SHA', '.']
 # Push the container image to Container Registry
 - name: 'gcr.io/cloud-builders/docker'
   args: ['push', 'gcr.io/$PROJECT_ID/portfolio-website:$COMMIT_SHA']
 # Deploy container image to Cloud Run
 - name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
   entrypoint: gcloud
   args:
   - 'run'
   - 'deploy'
   - '${NAME}'
   - '--image'
   - 'gcr.io/$PROJECT_ID/portfolio-website:$COMMIT_SHA'
   - '--region'
   - 'us-central1'
   - '--platform'
   - 'managed'
   - '--allow-unauthenticated'
 images:
 - 'gcr.io/$PROJECT_ID/portfolio-website:$COMMIT_SHA'
cmd /c gcloud services enable deploymentmanager.googleapis.com  
cmd /c gcloud services enable compute.googleapis.com
cmd /c gcloud services enable dataflow.googleapis.com
cmd /c gcloud services enable cloudbuild.googleapis.com
cmd /c gcloud services enable cloudfunctions.googleapis.com
cmd /c gcloud compute project-info add-metadata --metadata google-compute-default-region=europe-west1
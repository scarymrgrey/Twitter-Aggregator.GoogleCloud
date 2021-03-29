gcloud services enable deploymentmanager.googleapis.com  
gcloud services enable compute.googleapis.com
gcloud services enable dataflow.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable cloudfunctions.googleapis.com
gcloud compute project-info add-metadata --metadata google-compute-default-region=europe-west1
gsutil mb gs://${BUCKET_NAME}
zip -r -j ./src/agg/artifact.zip ./src/agg
zip -r -j ./src/consumer/artifact.zip ./src/consumer
zip -r -j ./src/http-server/artifact.zip ./src/http-server
gsutil cp ./src/agg/artifact.zip gs://${BUCKET_NAME}/agg/
gsutil cp ./src/consumer/artifact.zip gs://${BUCKET_NAME}/consumer/
gsutil cp ./src/http-server/artifact.zip gs://${BUCKET_NAME}/http-server/
gcloud deployment-manager deployments create fedex-twitter-deployment --config deployment.yaml
gcloud dataflow jobs run pubsub2bq --region europe-west1 --gcs-location gs://dataflow-templates/latest/PubSub_Subscription_to_BigQuery --staging-location gs://${BUCKET_NAME}/staging --parameters inputSubscription=projects/${PROJECT_NAME}/subscriptions/pubsub2bq,outputTableSpec=${PROJECT_NAME}:tweetsds.tweets
gcloud functions call consume_feed --region europe-west1 --data  "{\"data\":\"CONSUME_FEED\"}"
gcloud functions add-iam-policy-binding expose_data_http --region europe-west1 --member="allUsers" --role="roles/cloudfunctions.invoker" 
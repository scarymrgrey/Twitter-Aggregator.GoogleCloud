gcloud functions deploy aggregate_feed --source ./src/agg --entry-point tweets_control_pubsub --trigger-topic CONTROL_QUEUE --runtime python38 --set-env-vars projectId=$PROJECT_NAME
gcloud functions deploy consume_feed --source ./src/consumer --set-env-vars TWITTER_API_KEY=%TWITTER_API_KEY%,TWITTER_API_SECRET_KEY=%TWITTER_API_SECRET_KEY%,TWITTER_ACCESS_TOKEN=%TWITTER_ACCESS_TOKEN%,TWITTER_ACCESS_TOKEN_SECRET=%TWITTER_ACCESS_TOKEN_SECRET%,COUNTRY=Netherlands,DATE_SINCE=%DATE_SINCE% --entry-point consume_feed --trigger-topic CONTROL_QUEUE --runtime python38
gcloud dataflow jobs run pubsub2bq --gcs-location gs://dataflow-templates/latest/PubSub_Subscription_to_BigQuery --staging-location gs://[YOUR_BUCKET_NAME_HERE]/staging --parameters inputSubscription=projects/${PROJECT_NAME}/subscriptions/pubsub2bq,outputTableSpec=${PROJECT_NAME}:tweetsds.tweets
gcloud functions call consume_feed --data "{\"data\":\"CONSUME_FEED\"}"
gcloud functions deploy expose_data_http --source ./src/http-server --entry-point start_http --trigger-http --runtime python38 --allow-unauthenticated
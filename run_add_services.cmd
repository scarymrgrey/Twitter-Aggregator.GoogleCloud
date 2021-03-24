cmd /c gcloud services enable compute.googleapis.com
cmd /c gcloud services enable dataflow.googleapis.com
cmd /c gcloud services enable cloudbuild.googleapis.com
cmd /c gcloud services enable cloudfunctions.googleapis.com
cmd /c gcloud compute project-info add-metadata --metadata google-compute-default-region=europe-west1
cmd /c gsutil mb gs://feedex-tweets-bucket
cmd /c gcloud pubsub topics create tweets-topic
cmd /c gcloud pubsub subscriptions create pubsub2bq --topic=tweets-topic --topic-project=fedex-twitter
cmd /c bq --location=EU mk --dataset --default_table_expiration 7200 --default_partition_expiration 7200 --description "tweets ds" fedex-twitter:tweetsds
cmd /c bq mk --table --description "aggregated tweets" fedex-twitter:tweetsds.aggregated trends:STRING,count:INTEGER
cmd /c bq mk --table --description "tweets" fedex-twitter:tweetsds.tweets tweet_text:STRING
cmd /c gcloud dataflow jobs run pubsub2bq --gcs-location gs://dataflow-templates/latest/PubSub_Subscription_to_BigQuery --staging-location gs://feedex-tweets-bucket/staging --parameters inputSubscription=projects/fedex-twitter/subscriptions/pubsub2bq,outputTableSpec=fedex-twitter:tweetsds.tweets
cmd /c gcloud pubsub topics create CONTROL_QUEUE
cmd /c gcloud functions deploy aggregate_feed --source ./src/agg --entry-point tweets_control_pubsub --trigger-topic CONTROL_QUEUE --runtime python38
cmd /c gcloud functions deploy consume_feed --source ./src/consumer --set-env-vars TWITTER_API_KEY=%TWITTER_API_KEY%,TWITTER_API_SECRET_KEY=%TWITTER_API_SECRET_KEY%,TWITTER_ACCESS_TOKEN=%TWITTER_ACCESS_TOKEN%,TWITTER_ACCESS_TOKEN_SECRET=%TWITTER_ACCESS_TOKEN_SECRET%,COUNTRY=Netherlands,DATE_SINCE=%DATE_SINCE% --entry-point consume_feed --trigger-topic CONTROL_QUEUE --runtime python38
cmd /c gcloud functions call consume_feed --data "{\"data\":\"CONSUME_FEED\"}"
gcloud functions deploy expose_data_http --source ./src/http-server --entry-point start_http --trigger-http --runtime python38 --allow-unauthenticated
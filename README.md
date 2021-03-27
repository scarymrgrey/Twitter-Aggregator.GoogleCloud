# Twitter-Aggregator.GoogleCloud - POC


## Prerequisites:
- GCP Account
- Billing Account
- gcloud CLI installed

## General info
Unfortunately I haven't found nice and easy way to include Dataflow resource into the deployment conf so several additional commands are needed to deploy it.
Jinja templating is used in order to keep configuration separatly from blueprint.

Branches:

    - https://github.com/scarymrgrey/Twitter-Aggregator.GoogleCloud
    - https://github.com/scarymrgrey/Twitter-Aggregator.GoogleCloud/tree/gcp-deployment-manager

## How to run

1) in cmd - ```gcloud projects create [PROJECT_NAME] --set-as-default```
2) Open "deployment.yaml" file and edit lines 9-17
3) in GCP Console - link project ```[PROJECT_NAME]``` to your valid billing account
4) in cmd - ```win/nix_enable_services.cmd/sh```
5) in cmd - ```gcloud deployment-manager deployments create fedex-twitter-deployment --config deployment.yaml```
6) in cmd - ```gcloud dataflow jobs run pubsub2bq --gcs-location gs://dataflow-templates/latest/PubSub_Subscription_to_BigQuery --staging-location gs://[YOUR_BUCKET_NAME_HERE]/staging --parameters inputSubscription=projects/[PROJECT_NAME]/subscriptions/pubsub2bq,outputTableSpec=[PROJECT_NAME]:tweetsds.tweets```
7) in cmd - ```gcloud functions call consume_feed --data "{\"data\":\"CONSUME_FEED\"}"```


![Screenshot](Twitter-consumer.png)

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
0) ```export PROJECT_NAME=YOUR_VALUE```
1) ```gcloud projects create $PROJECT_NAME --set-as-default```
2) Open "deployment.yaml" file and edit lines 9-17
3) in GCP Console - link project ```[PROJECT_NAME]``` to your valid billing account
4) ```export BUCKET_NAME=YOUR_VALUE```
5) ```chmod 755 deploy_all.sh ```
6) ```./deploy_all.sh```



![Screenshot](Twitter-consumer.png)

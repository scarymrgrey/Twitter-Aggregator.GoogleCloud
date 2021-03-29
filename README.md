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
1) in cmd - ```set PROJECT_NAME=your_value```
2) in cmd - ```gcloud projects create %PROJECT_NAME% --set-as-default```
3) in GCP Console - link project ```[PROJECT_NAME]``` to your valid billing account
4) Open "deployment.yaml" file and edit lines 9-11
5) in cmd - ```set TWITTER_API_KEY=your_value```
6) in cmd - ```set TWITTER_API_SECRET_KEY=your_value```
7) in cmd - ```set TWITTER_ACCESS_TOKEN=your_value```
8) in cmd - ```set TWITTER_ACCESS_TOKEN_SECRET=your_value```
9) in cmd - ```set DATE_SINCE=202103220000```
10) in cmd - ```win/nix_enable_services.bat/sh```
11) in cmd - ```gcloud deployment-manager deployments create fedex-twitter-deployment --config deployment.yaml```
12) in cmd - ```win/nix_deploy_functions.bat/sh```


![Screenshot](Twitter-consumer.png)

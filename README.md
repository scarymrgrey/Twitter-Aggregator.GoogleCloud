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
3) Open "deployment.yaml" file and edit lines 9-17
4) in GCP Console - link project ```[PROJECT_NAME]``` to your valid billing account
5) in cmd - ```win/nix_enable_services.bat/sh```
6) in cmd - ```gcloud deployment-manager deployments create fedex-twitter-deployment --config deployment.yaml```
7) in cmd - ```win/nix_deploy_functions.bat/sh```


![Screenshot](Twitter-consumer.png)

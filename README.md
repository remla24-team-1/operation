This Organization, designed my team 1 of the Remla course in Tu Delft, is made to detect phishing links. In this file, the architecture, repositories and more will be provided. 

## High-level Architecture

## How to start the Application

### Parameters

### Variables

### Requirements

## Understanding the codebase: Relevant files

## List of Project Repositories

https://github.com/remla24-team-1/operation
https://github.com/remla24-team-1/model-training
https://github.com/remla24-team-1/lib-version
https://github.com/remla24-team-1/model-service
https://github.com/remla24-team-1/lib-ml
https://github.com/remla24-team-1/app

## Assignments Progress Log

### Assignment 1: Configuration Management

Seperated out the original Kaggle notebook into different subsections of ML training. More specifically into: 

> build_features.py : loads text data from files as specified in Yaml and performs preprocessing of the data
> model_definition.py: defines the model architecture following config.yml
> train_model.py: loads data
> predict_model.py : loads the trained neural network and creates 
> make_dataset.py: creates and downloads dataset from cloud service


### Assignment 2

> app:

> lib-ml:

> lib-version:

> model-service:

> model-training:

> operation: This is the central repo that contains all the information for running the application and operating the cluster. To run the repository with the latest container versions, run:
```
git clone git@github.com:remla24-team-1/operation.git
cd operation
```
And finally
```
docker compose up
```
to collect and build the application.

# Usage
The service is served through a proxy, at ```localhost:8080``` and ```localhost:80```. After starting the container, go to either of these pages in your browser of choice to test out the service.




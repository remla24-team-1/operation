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

The service is served through a proxy, at `localhost:8080` and `localhost:80`. After starting the container, go to either of these pages in your browser of choice to test out the service.

# VAGRANT - ANSIBLE - KUBERNETES

## Current run instructions

Run with `vagrant up` in main directory. You may want to register your public ssh key if you have not done so already for Ansible. (Not 100% sure if you have to)

## Vagrant structure

Check the vagrant-file.
Basics:

- controller built and added to controller group in ansible
- nodes built (node{i}) and added to nodes group
- Everything is configurable
- Dynamic Ansible inventory is used rather than static
- Provisions using provision.yml
- IPs are automatically allocated as a private network within VirtualBox - 192.168.56.3 for controller. One address later for every node (i.e. 192.168.56.4, 5 etc).
- All nodes can reach each other freely over this network.

## Ansible structure

- Tasks in `roles/` are performed according to roles
- Order is common, controller, nodes
- Common tasks includes downloading and installing containerd, docker, kubectl, kubeadm, kubelet and starting these services

## Kubernetes status

- Initializes on controller through `kubeadm init [*PARAMS]`
- Advertises on `192.168.56.3`, the network where all VMs can reach each other
- Deploys Calico network on controller
- Saves `kubeadm token create --print-join-command` output to /tmp/joincommand.txt on host running the command as the user running vagrant
- Loads file containing command using `slurp` and runs the command on all nodes

This should be incredibly scalable for the amount of nodes. Not as clear for adding more controllers in this framework.

## Upcoming

- Initialize minikube or similar on host. Currently k3d gets installed automaticaly for all hosts, but has not yet been tried.

## Running the project

- Make sure you have installed kubectl, minikube, docker desktop, and helm.
- In docker desktop, go to settings and enable kubernetes.
- Make sure docker desktop is open during the following steps.
- Create a cluster by running: `minikube start`
- Install the project by running: `helm install url-phishing-checker helm-chart`
- Make the project available on localhost by running: `minikube tunnel`
- When you're done, uninstall the project by running the following command: `helm uninstall url-phishing-checker`

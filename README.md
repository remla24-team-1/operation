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

- Initialize minikube or similar on host.

## Running the project

- Make sure you have installed kubectl, minikube, docker desktop, and helm.
- In docker desktop, go to settings and enable kubernetes.
- Make sure docker desktop is open during the following steps.
- Create a cluster by running: `minikube start`
- Start the minikube ingress through `minikube addons enable ingress`
- Install the project by running: `helm install url-phishing-checker helm-chart`
- Make the project available on localhost by running: `minikube tunnel`
- When you're done, uninstall the project by running the following command: `helm uninstall url-phishing-checker`

## ISTIO SERVICE MESH

These are full run instructions for running the minikube cluster and to enable the istio service mesh.

- Make sure kubectl, minikube, docker-desktop and helm are installed.
- Make sure that you are logged into docker-desktop. This might require you to initialise your pass, through for example gpg keys, see the [Docker documentation](https://docs.docker.com/desktop/get-started/#credentials-management-for-linux-users).
- Enable kubernetes in docker desktop.
- Create a cluter by running `minikube start`
- (Get an overview of the deployment through the minikube dashboard by running `minikube dashboard`.)
- Download a istio binary that fits your system from [the Istio github releases page](https://github.com/istio/istio/releases/tag/1.22.0)
- Unpack the downloaded binary with `tar -xvzf {ISTIO RELEASE}.tar`. (Optionally: Move the unpacked folder to another location. We will assume that the unpacked folder is located at `~/istio` from now on)
- Optional: Add the istio/bin folder to your path. This can be done by running `EXPORT PATH=$PATH:~/istio/bin` after moving the unpacked folder.
- Verify that istio has been added to your path by running `istioctl version`. This should return the version.
- Install istio to the cluster by running `istioctl install`.
- Install Prometheus, Jaeger and Kiali by running:

```
kubectl apply -f ~/istio/samples/addons/prometheus.yaml
kubectl apply -f ~/istio/samples/addons/jaeger.yaml
kubectl apply -f ~/istio/samples/addons/kiali.yaml
```

The prometheus and kiali dashboards are available through running `istioctl dashboard prometheus` and/or `istioctl dashboard kiali`

- Label the namespace for Istio injection with `kubectl label namespace default istio-injection=enabled`
- Deploy the helm chart with `helm install url-phishing-checker helm-chart`. (If the helm chart has already been deployed on your minikube cluster, the pods can be reloaded to also initialize the Istio sidecars by running `helm upgrade url-phishing-checker helm-chart --recreate-pods`)
- Apply the gateway by running `kubectl apply -f gateway.yaml`.
- Apply the virtual service by running `kubectl apply -f VirtualService.yaml`.
- Apply the rate limiting by running `kubectl apply -f envoyfilter.yaml`.
- Open a tunnel for the istio-ingressway to bind to by running `minikube tunnel`. While the command is active, the service will be accessible at a specific address.
- (Get the external IP that the service is deployed at by running `kubectl get svc istio-ingressgateway -n istio-system`. This should be 127.0.0.1.)
- Test the service by going to the url, likely [localhost](localhost).

# Operation
Operations repo for the URL Phishing detection deployment. Contains overview of the deployment, run instructions for local testing as well as deployment instructions.

## List of All Project Repositories

[operation](https://github.com/remla24-team-1/operation)
[model-training](https://github.com/remla24-team-1/model-training)
[lib-version](https://github.com/remla24-team-1/lib-version)
[model-service](https://github.com/remla24-team-1/model-service)
[lib-ml](https://github.com/remla24-team-1/lib-ml)
[app](https://github.com/remla24-team-1/app)

## Run instructions

First, clone the repository to your local device and enter the operations folder using
```
git clone git@github.com:remla24-team-1/operation.git
cd operation
```

### Alternative 1: Local Docker deployment
Run
```
docker compose up
```
to collect and build the application.

The service is served through a proxy, at `localhost:8080` and `localhost:80`. After starting the container, go to either of these pages in your browser.

### Alternative 2: Local Minikube cluster - without Istio service mesh

- Make sure Kubectl, Minikube, Docker Desktop and Helm are installed.
- Make sure that you are logged into Docker Desktop. This might require you to initialise your pass, through for example gpg keys, see the [Docker documentation](https://docs.docker.com/desktop/get-started/#credentials-management-for-linux-users).
- Enable kubernetes in docker desktop.
- Make sure Docker Desktop is open during the following steps.
- Create a cluster by running: `minikube start --memory=6144 --cpus=4 --driver=docker`
- Start the minikube ingress through `minikube addons enable ingress`
- Install the project by running: `helm install url-phishing-checker helm-chart`
- Make the project available on localhost by running: `minikube tunnel`
- When you're done, uninstall the project by running the following command: `helm uninstall url-phishing-checker`

### Alternative 3: Local Minikube cluster - with Istio service mesh

- Make sure Kubectl, Minikube, Docker Desktop and Helm are installed.
- Make sure that you are logged into Docker Desktop. This might require you to initialise your pass, through for example gpg keys, see the [Docker documentation](https://docs.docker.com/desktop/get-started/#credentials-management-for-linux-users).
- Enable Kubernetes in Docker Desktop.
- Create a local cluster by running `minikube start --memory=6144 --cpus=4 --driver=docker`
- (Get an overview of the deployment through the minikube dashboard by running `minikube dashboard`.)
- Download a Istio binary that fits your system from [the Istio github releases page](https://github.com/istio/istio/releases/tag/1.22.0)
- Unpack the downloaded binary with `tar -xvzf {ISTIO RELEASE}.tar`. (Optionally: Move the unpacked folder to another location. We will assume that the unpacked folder is located at `~/istio` from now on)
- Optional: Add the istio/bin folder to your path. This can be done by running `EXPORT PATH=$PATH:~/istio/bin` after moving the unpacked folder.
- Verify that istio has been added to your path by running `istioctl version`. This should return the version.
- Install istio to the cluster by running `istioctl install`.
- Install Prometheus by running: `kubectl apply -f ~/istio/samples/addons/prometheus.yaml`. The prometheus dashboard is then available through running `istioctl dashboard prometheus`.
- Label the namespace for Istio injection with `kubectl label namespace default istio-injection=enabled`.
- Deploy the helm chart with `helm install url-phishing-checker helm-chart`. (If the helm chart has already been deployed on your minikube cluster, the pods can be reloaded to also initialize the Istio sidecars by running `helm upgrade url-phishing-checker helm-chart --recreate-pods`)
- Open a tunnel for the Istio-ingressway to bind to by running `minikube tunnel`. While the command is active, the service will be accessible at a specific address.
- (Get the external IP that the service is deployed at by running `kubectl get svc istio-ingressgateway -n istio-system`. This should be 127.0.0.1.)
- Test the service by going to the url, likely [localhost](localhost).

### Alternative 4: VM provisioning

- Make sure that [Vagrant](https://developer.hashicorp.com/vagrant/install), [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) and [VirtualBox](https://www.virtualbox.org/) are installed, and that Vagrant is set to use VirtualBox as a provider.
- Set your deployment settings, for example the amount of nodes, the memory assigned to each node and to the controller, the amount of CPUs and similar by modifying the parameters within the `Vagrantfile`.
- Start the VM:s by running `vagrant up`. This also provision the VM:s through the Ansible playbook at `provision.yml`.

#### Details about the provisioning deployment

This deployment strategy uses [k3s](https://k3s.io/) as the Kubernetes distribution, which allows new nodes to join the cluster easily. The service gets exposed on the VirtualBox network shared with the hosting device, and is accessible at `192.168.56.3`. To access the controller VM itself, connect to it using `vagrant ssh`. From there you can get the pod states as usual through `kubectl get pods -n default`, get an overview of the resource usage for the cluster through `kubectl top nodes`.

# Assessing Kubernetes

This is a very simple Rails app that runs:

1. a web service that responds with the `hostname` where the app is running and
with the `count` of a MySQL table;

2. a rake task (simulating a worker) that add rows to a MySQL table every 1
second.


## Running with Docker Compose

```shell
docker-compose run web bundle install
docker-compose run web bundle exec rake db:create db:migrate
docker-compose up
```

## Running a development (local) environment with Kubernetes

1. First Time Setup
```shell
./kubernetes/setup.sh
```
2. Deploying a New Image (for setting up or any changes)
  - Remember to change files: kubernetes/deployments -> web.yaml and worker.yaml
  to match the version
```shell
./kubernetes/build.sh <version>
./kubernetes/deploy.sh
```
Check that everything is running:
  - `kubectl get deployments`
  - `kubectl get pods`
  - `kubectl get services`
  - `kubectl get pvc`
  - `kubectl get pv`
  - Access via browser localhost:3100


## Deploying a production environment with Kubernetes

> TODO

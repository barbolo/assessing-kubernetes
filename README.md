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

1. Create a CLOUDSQL instance and access
  - Create MYSQL - GEN 2 instance with desired attributes

  - Create a service account
    - Role: CloudSQL Client
    - Give it a name and id
    - Check `Furnish a new private key`
    - `Create`
    - Save the file (`<proxy_key_file>`)

  - Create DB user that uses cloudproxy (can also be done via console)
    - `gcloud sql users create assessing-k8s cloudsqlproxy~% --instance=<nome_da_instancia_sql> --password=<sql_pass>`

2. Create cluster via kubernetes engine console (easier to choose options)
  - Get cluster credentials
    - `gcloud container clusters get-credentials assessing-kube-cluster`
  - Set cluster as context for kubectl
    - `kubectl config set-context gce`

3. Create kubernetes secrets (used by pods, like password and credentials)
  - `kubectl create secret generic cloudsql-instance-credentials --from-file=credentials.json=<proxy_key_file>`
  - `kubectl create secret generic assessing-kubernetes-secrets --from-literal=db_pass='<pass-sql> --from-literal=rails_master_key=<key>`

4. Build images
  - `sh <PROJECT_DIR>/kubernetes-prod/build.sh <version>`

5. Update deployments yamls
  - In the yamls, under the tag 'images' set the `<version>` accordingly

6. Deploy
  - `sh <PROJECT_DIR>/kubernetes-prod/deploy.sh`

## USEFULL commands, and other
### Use the Dashboard
- Run `sh <PROJECT_DIR>/kubernetes-prod/dashboard/dashboard.sh`
- Copy the token from output
- Access localhost:8001 (if using cloudshell click preview web)
- Change last path to `ui`
- Paste token

### Rollout updates
- Repeat steps 4-6 with new version

### Rollback
- Rollback to last previous:
  - `kubectl rollout undo deployment/nginx-deployment`
- Check rollout history:
  - `kubectl rollout history deployment/nginx-deployment`
- Rollback to specific revision:
  - `kubectl rollout undo deployment/nginx-deployment --to-revision=<n>`

### Scale
- Manual
  - `kubectl scale deployment nginx-deployment --replicas=10`
- Auto (based on cpu_usage)
  - Enable `resource metrics API`
  - `kubectl autoscale deployment <deployment_name> --cpu-percent=50 --min=1 --max=10`
- Create and stop load (to test)
  - `kubectl run -i --tty load-generator --image=busybox /bin/sh`
  - New prompt opens, run: `while true; do wget -q -O- <service>; done`
  - Check increase in number of pods in different terminal
  - Stop: `CTRL+C` or `exit` in the busybox terminal

### Pause and resume deployment
- Pause:
  - `kubectl rollout pause deployment <deployment_name>`
- Resume:
  - `kubectl rollout resume deployment <deployment_name>`

### Change or set Resources
- CPU and memory limits
  - `kubectl set resources deployment <deployment_name> --limits=cpu=200m,memory=512Mi`

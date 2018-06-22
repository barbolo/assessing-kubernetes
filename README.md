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

> TODO

## Deploying a production environment with Kubernetes

> TODO

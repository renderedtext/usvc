# Micro-service (usvc)
Micro service skeleton can be created and deployed in 5 min.

## Install locally
Most of the logic is 'mix task'.
To make the task available in all directories for current user
download the repo and type:

```
MIX_ENV=prod mix compile
MIX_ENV=prod mix archive.build
MIX_ENV=prod mix archive.install
```

This adds family of `usvc` mix tasks.

## Usage

#### Create new micro-service:
```
mix usvc.new <svc_name>
```

Command creates new Elixir project and populates it with
'Hello' http server and some config files.
Http server listens on port 4000.

#### Change working directory to the project:
```
cd <svc_name>
```

#### Build docker image:
```
make build
```

#### Run tests against service API:
- run `make test` or `make run` and
- send requests to port 4000 (e.g. `curl localhost:4000/`)

#### Deploy
To create initial deploy
```
make create-deploy
```

To redeploy:
```
make redeploy
```

This command deploys to `default` k8s cluster.
Before deploy, it pushes docker image to DockerHub.

Note: By default k8s uses `dockerhub-secrets` secret to pull image from DockerHub.
`dockerhub-secrets` contains `rtrobot` DockerHub user's credentials.
To grant `rtrobot` permission to pull image
you need to give `read` permissions on your new service image
to DockerHub team `deployers`.

### Local development

#### Console
Starts interactive docker image with mounted project directories
```
make console
```

#### File watcher
To automaticaly recompile and run tests on each file change
```
make watch
```

### Build targets
Build target creates docker image called `renderedtext/<svc_name>`
with these tags:
- `latest`
- `<git_hash>-<SEMAPHORE_EXECUTABLE_UUID>`

## Micro-service k8s cluster entry-point
After the micro-service initial deployment, it is not visible outside the
k8s cluster.

In order to communicate with the service you must either:
- Create request from within the cluster or
- Create load balancer and make the micro-service accessible from outside the cluster.

### Create request from within the cluster
When new micro-service is first deployed k8s entity called 'service'
of type `NodePort` is created.
It creates stable IP address within cluster for the micro-service.
After each successful deploy, this entity's configuration is shown.
It looks like this:
```
NAME      CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
<usvc>    100.67.25.213   <nodes>       4000:30195/TCP   4d
```

The configuration tells us that the micro-service is,
within the cluster, accessible on IP *100.67.25.213* and port *4000*
(disregard the second port number).

To send request from within the cluster you need to create container
in the cluster (or use existing one) to issue requests from.
Simplest way is to ssh to some container within the cluster:
```
make k8s-shell
```

and issue requests from it:
```
ssh curl <cluster-ip>:<port>
```

### Create load balancer
There are two types of load balancers in AWS
- Traditional ELB  and
- Application LB (ALB)

Latter is preferred one in RT.
In k8s terminology, ALB is called *ingress*.

There is one cluster wide ingress.
To register your new micro-service in it, edit the [configuration file](https://github.com/renderedtext/aws-k8s-ingress/blob/master/staging.yml).

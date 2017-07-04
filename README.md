# Micro-service
Micro service skeleton can be created and deployed in 5 min.

## Install locally
```
MIX_ENV=prod mix compile
MIX_ENV=prod mix archive.build
MIX_ENV=prod mix archive.install
```

## Usage

Create new micro-service:
```
mix usvc.new <svc_name>
```

Command creates new Elixir project and populates it with
'Hello' http server and some config files.
Http server listens on port 4000.

Change working directory to the project:
```
cd <svc_name>
```

Buid docker image:
```
make
```

And run tests against service API:
- run `make test` or `make run` and
- send requests to port 4000 (e.g. `curl localhost:4000/`)

### Make targets
There are couple `make` targets:
- `build` [default] - build docker image
- `run` - `docker run ...` with container port 4000 exposed on host port 4000
- `test` - `docker-compose up`
- `push` - `docker push`
- `pull` - `docker pull`
- `deploy` (not done yet) - `kubectl apply -f deploy.yml` to staging cluster only (for now)

Build target creates docker image called `renderedtext/<svc_name>`
with 3 tags:
- `latest`
- `<git_hash>`
- `<git_hash>-<SEMAPHORE_EXECUTABLE_UUID>`

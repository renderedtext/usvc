.PHONY: build push


TAG=1.4.5-v2
REPO_EX=renderedtext/elixir
REPO_DEV=renderedtext/elixir-dev
IMAGE_EX=$(REPO_EX):$(TAG)
IMAGE_DEV=$(REPO_DEV):$(TAG)
IMAGE_EX_LATEST=$(REPO_EX):latest
IMAGE_DEV_LATEST=$(REPO_DEV):latest

build: .elixir .dev

.elixir: Dockerfile.elixir
	docker build --cache-from $(IMAGE_EX_LATEST) -t $(IMAGE_EX) -f $< .
	docker tag $(IMAGE_EX) $(IMAGE_EX_LATEST)
	touch $@

.dev: Dockerfile.dev
	docker build --cache-from $(IMAGE_DEV_LATEST) -t $(IMAGE_DEV) -f $< .
	docker tag $(IMAGE_DEV) $(IMAGE_DEV_LATEST)
	touch $@
	

push: build
	docker push $(IMAGE)
	docker push $(IMAGE_LATEST)


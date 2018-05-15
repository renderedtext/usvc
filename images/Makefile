.PHONY: build push


export TAG_BASE=1.2.6
export TAG=$(TAG_BASE)-v2
REPO_EX=renderedtext/elixir
REPO_DEV=renderedtext/elixir-dev
REPO_DEV_GUI=renderedtext/elixir-dev-gui
IMAGE_EX=$(REPO_EX):$(TAG)
IMAGE_DEV=$(REPO_DEV):$(TAG)
IMAGE_DEV_GUI=$(REPO_DEV_GUI):$(TAG)
IMAGE_EX_LATEST=$(REPO_EX):latest
IMAGE_DEV_LATEST=$(REPO_DEV):latest
IMAGE_DEV_GUI_LATEST=$(REPO_DEV_GUI):latest

build: .elixir .dev .dev-gui


Dockerfile.elixir: Dockerfile.elixir.template Makefile
	envsubst '$${TAG_BASE}' < $< > $@

Dockerfile.dev: Dockerfile.dev.template Makefile
	envsubst '$${TAG}' < $< > $@

Dockerfile.dev-gui: Dockerfile.dev-gui.template Makefile
	envsubst '$${TAG}' < $< > $@

.elixir: Dockerfile.elixir
	docker build --cache-from $(IMAGE_EX_LATEST) -t $(IMAGE_EX) -f $< .
	docker tag $(IMAGE_EX) $(IMAGE_EX_LATEST)
	touch $@

.dev: Dockerfile.dev .elixir
	docker build --cache-from $(IMAGE_DEV_LATEST) -t $(IMAGE_DEV) -f $< .
	docker tag $(IMAGE_DEV) $(IMAGE_DEV_LATEST)
	touch $@

.dev-gui: Dockerfile.dev-gui .dev
	docker build --cache-from $(IMAGE_DEV_GUI_LATEST) -t $(IMAGE_DEV_GUI) -f $< .
	docker tag $(IMAGE_DEV_GUI) $(IMAGE_DEV_GUI_LATEST)
	touch $@

push: build
	docker push $(IMAGE_EX)
	docker push $(IMAGE_DEV)
	docker push $(IMAGE_DEV_GUI)
	docker push $(IMAGE_EX_LATEST)
	docker push $(IMAGE_DEV_LATEST)
	docker push $(IMAGE_DEV_GUI_LATEST)

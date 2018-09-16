DOCKER_REPO = owend/github-org-repos-resource
TAG ?= latest
CONF_FILE ?= .confs/check.json
SCRATCH_DIR = scratch

$(SCRATCH_DIR):
	mkdir -p $@

.PHONY: build
build:
	stack build

.PHONY: build-docker
build-docker:
	docker build -t $(DOCKER_REPO):$(TAG) .

.PHONY: run-check
run-check: build
	cat $(CONF_FILE) | stack exec check

.PHONY: run-in
run-in: build | $(SCRATCH_DIR)
	cat $(CONF_FILE) | stack exec in $(SCRATCH_DIR)

.PHONY: run-out
run-out: build
	stack exec out

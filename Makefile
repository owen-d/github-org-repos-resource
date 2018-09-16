DOCKER_REPO = owend/gihub-org-repos-resource
TAG ?= latest
CONF_FILE ?= .confs/check.json
SCRATCH_DIR = scratch
OUTPUT_FILE = $(SCRATCH_DIR)/repos.json

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
	cat $(CONF_FILE) | stack exec in $(OUTPUT_FILE)

.PHONY: run-out
run-out: build
	stack exec out

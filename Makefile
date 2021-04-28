OWNER:=miyamonz

# see https://hub.docker.com/r/nvidia/cuda
CUDA_VERSION:=10.1
TYPE:=cudnn7-devel
BASE_OS:=ubuntu18.04
CUDA_TAG:=$(CUDA_VERSION)-$(TYPE)-$(BASE_OS)
ROOT_CONTAINER:=nvidia/cuda:$(CUDA_TAG)

# put `-gpu` suffix on every image
# base-notebook-$(CUDA_TAG) may be good if you want
BASE_CONTAINER:=$(OWNER)/base-notebook-gpu

build/base-notebook: BUILD_ARG:=ROOT_CONTAINER=$(ROOT_CONTAINER)

# note: `make build/minimal-notebook` will create `$(OWNER)/minimal-notebook-gpu`.
build/%: DARGS?=
build/%: BUILD_ARG?=BASE_CONTAINER=$(BASE_CONTAINER)
build/%: IMAGE_NAME=$(OWNER)/$(notdir $@)-gpu
build/%: ## build the latest image for a stack
	docker build $(DARGS) --build-arg $(BUILD_ARG) --rm --force-rm -t $(IMAGE_NAME):latest ./docker-stacks/$(notdir $@)
	@echo -n "Built image size: "
	@docker images $(IMAGE_NAME):latest --format "{{.Size}}"

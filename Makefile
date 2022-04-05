
default: build

# user args
COMPUTE?=cpu
ROS_DISTRO?=foxy
TEST_CONFIG?=test.yaml

# defaults
BASE_OS?=ubuntu:focal
DOCKER_FILE?=Dockerfile.ros2.ubuntu.x86_64

ifeq ($(ROS_DISTRO), galactic)
	ifeq ($(COMPUTE), cpu)
		DOCKER_FILE=Dockerfile.ros2.ubuntu
		BASE_OS=ubuntu:focal
	else ifeq ($(COMPUTE), cuda)
		DOCKER_FILE=Dockerfile.ros2.ubuntu.cuda
		BASE_OS=nvidia/cuda:11.5.1-cudnn8-devel-ubuntu20.04
	endif
else ifeq ($(ROS_DISTRO), foxy)
	ifeq ($(COMPUTE), cpu)
		DOCKER_FILE=Dockerfile.ros2.ubuntu
		BASE_OS=ubuntu:focal
	else ifeq ($(COMPUTE), cuda)
		DOCKER_FILE=Dockerfile.ros2.ubuntu.cuda
		BASE_OS=nvidia/cuda:11.5.1-cudnn8-devel-ubuntu20.04
	endif
else ifeq ($(ROS_DISTRO), eloquent)
	ifeq ($(COMPUTE), cpu)
		DOCKER_FILE=Dockerfile.ros2.ubuntu
		BASE_OS=ubuntu:bionic
	else ifeq ($(COMPUTE), cuda)
		DOCKER_FILE=Dockerfile.ros2.ubuntu.cuda
		BASE_OS=nvidia/cuda:11.5.0-cudnn8-devel-ubuntu18.04
	endif
else ifeq ($(ROS_DISTRO), dashing)
	ifeq ($(COMPUTE), cpu)
		DOCKER_FILE=Dockerfile.ros2.ubuntu
		BASE_OS=ubuntu:bionic
	else ifeq ($(COMPUTE), cuda)
		DOCKER_FILE=Dockerfile.ros2.ubuntu.cuda
		BASE_OS=nvidia/cuda:11.5.0-cudnn8-devel-ubuntu18.04
	endif
endif


IMAGE_NAME=ros2-images
TAG_NAME?=${ROS_DISTRO}
ifeq ($(COMPUTE), cpu)
	TAG_NAME=${ROS_DISTRO}
else ifeq ($(COMPUTE), cuda)
	TAG_NAME=${ROS_DISTRO}-cuda
endif
DOCKER_PUSH_REGISTRY?=ameyawagh
DOCKER_IMAGE= ${DOCKER_PUSH_REGISTRY}/${IMAGE_NAME}

build:
	@echo "building ..."
	docker build \
	-f docker/${DOCKER_FILE} \
	--target ros2_base \
	--build-arg BASE=${BASE_OS} \
	--build-arg ROS_DISTRO=${ROS_DISTRO} \
	--tag ${DOCKER_IMAGE}:${TAG_NAME}-base \
	.
	docker build \
	-f docker/${DOCKER_FILE} \
	--target ros2_full \
	--build-arg BASE=${BASE_OS} \
	--build-arg ROS_DISTRO=${ROS_DISTRO} \
	--tag ${DOCKER_IMAGE}:${TAG_NAME}-full \
	.

push:
	@echo "pushing ..."
	docker push ${DOCKER_IMAGE}:${TAG_NAME}-base
	docker push ${DOCKER_IMAGE}:${TAG_NAME}-full

prune:
	docker system prune

test:
	container-structure-test test --image ${DOCKER_IMAGE}:${TAG_NAME}-full --config ${TEST_CONFIG}

clean: prune
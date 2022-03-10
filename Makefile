
default: build

AARCH?=x86_64
ROS_DISTRO?=foxy
BASE_OS?=ubuntu:focal
DOCKER_FILE?=Dockerfile.ros2.ubuntu.x86_64

ifeq ($(AARCH), x86_64)
	AARCH=x86_64
else ifeq ($(AARCH), cuda)
	AARCH=cuda

ifeq ($(ROS_DISTRO), galactic)
	BASE_OS=ubuntu:focal
else ifeq ($(ROS_DISTRO), foxy)
	BASE_OS=ubuntu:focal
else ifeq ($(ROS_DISTRO), eloquent)
	BASE_OS=ubuntu:bionic
else ifeq ($(ROS_DISTRO), dashing)
	BASE_OS=ubuntu:bionic
endif


DOCKER_FILE=Dockerfile.ros2.ubuntu.${AARCH}
IMAGE_NAME=ros2-images
TAG_NAME=${ROS_DISTRO}-${AARCH}
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

clean: prune
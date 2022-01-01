
default: build

AARCH?=x86_64
ROS_DISTRO?=foxy
BASE_OS?=ubuntu:focal
DOCKER_FILE?=Dockerfile.ros2.ubuntu.x86_64

ifeq ($(ROS_DISTRO), foxy)
	BASE_OS=ubuntu:focal
	OS_CODE_NAME=focal
	DOCKER_FILE=Dockerfile.ros2.ubuntu.${AARCH}
endif

IMAGE_NAME=ros2-images
TAG_NAME=${ROS_DISTRO}-${AARCH}
DOCKER_PUSH_REGISTRY?=ameyawagh
DOCKER_IMAGE= ${DOCKER_PUSH_REGISTRY}/${IMAGE_NAME}

build:
	@echo "building ..."
	docker build \
	-f docker/${DOCKER_FILE} \
	--build-arg base=${BASE_OS} \
	--build-arg OS_CODE_NAME=${OS_CODE_NAME} \
	--build-arg ROS_DISTRO=${ROS_DISTRO} \
	--tag ${DOCKER_IMAGE}:${TAG_NAME} \
	.

push:
	@echo "pushing ..."
	docker push ${DOCKER_IMAGE}:${TAG_NAME}

prune:
	docker system prune

clean: prune
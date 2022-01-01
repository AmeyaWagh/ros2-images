
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


build:
	@echo "building ..."
	docker build \
	-f docker/${DOCKER_FILE} \
	--build-arg base=${BASE_OS} \
	--build-arg OS_CODE_NAME=${OS_CODE_NAME} \
	--build-arg ROS_DISTRO=${ROS_DISTRO} \
	.

prune:
	docker system prune
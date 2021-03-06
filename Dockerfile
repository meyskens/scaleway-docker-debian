## -*- docker-image-name: "scaleway/docker" -*-
FROM scaleway/debian:amd64-jessie
# following 'FROM' lines are used dynamically thanks do the image-builder
# which dynamically update the Dockerfile if needed.
#FROM scaleway/debian:armhf-jessie	# arch=armv7l
#FROM scaleway/debian:arm64-jessie	# arch=arm64
#FROM scaleway/debian:i386-jessie	# arch=i386
#FROM scaleway/debian:mips-jessie	# arch=mips


MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)


# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter

# Install packages
RUN apt-get -q update                   \
 && apt-get --force-yes -y -qq upgrade  \
 && apt-get --force-yes install -y -q   \
	apparmor			\
	arping				\
	aufs-tools			\
	btrfs-tools			\
	bridge-utils                    \
	cgroup-bin			\
	git				\
	ifupdown			\
	kmod				\
	lxc				\
	python-setuptools               \
	vlan				\
 && apt-get clean


# Install Docker dependencies
RUN apt-get install $(apt-cache depends docker.io | grep Depends | sed "s/.*ends:\ //" | tr '\n' ' ')


# Install Docker
RUN curl -L https://get.docker.com/ | sh;                                                                                             


# Install Pipework
RUN wget -qO /usr/local/bin/pipework https://raw.githubusercontent.com/jpetazzo/pipework/master/pipework  \
 && chmod +x /usr/local/bin/pipework



# Install Docker Compose
RUN easy_install -U pip                                     \
 && pip install docker-compose                              \
 && ln -s /usr/local/bin/docker-compose /usr/local/bin/fig  \
 && docker-compose --version


# Install Docker Machine
ENV DOCKER_MACHINE_VERSION=0.6.0
RUN case "${ARCH}" in                                                                                                                                        \
    x86_64|amd64|i386)                                                                                                                                       \
        curl -L https://github.com/docker/machine/releases/download/v${DOCKER_MACHINE_VERSION}/docker-machine-Linux-x86_64 >/usr/local/bin/docker-machine && \
        chmod +x /usr/local/bin/docker-machine &&                                                                                                            \
	docker-machine --version;                                                                                                                            \
      ;;                                                                                                                                                     \
    *)                                                                                                                                                       \
	echo "docker-machine not yet supported for this architecture."                                                                                       \
      ;;                                                                                                                                                     \
    esac


# Patch rootfs
COPY ./overlay/usr /usr
COPY ./overlay/etc /etc
RUN systemctl disable docker; systemctl enable docker


# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave

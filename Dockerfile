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
RUN case "${ARCH}" in                                                                                 \
    armv7l|armhf|arm)                                                                                 \
    #  curl -s https://packagecloud.io/install/repositories/Hypriot/Schatzkiste/script.deb.sh | bash &&  \
    #  apt-get install docker-engine -y &&                                                                \
      dpkg -i /tmp/docker-engine_1.12.0.jessie_armhf.deb && \
      rm -f /tmp/docker-engine_1.12.0.jessie_armhf.deb && \
      systemctl enable docker;                                                                        \
      ;;                                                                                              \
    amd64|x86_64|i386)                                                                                \
      curl -L https://get.docker.com/ | sh;                                                           \
      ;;                                                                                              \
    *)                                                                                                \
      echo "Unhandled architecture: ${ARCH}."; exit 1;                                                \
      ;;                                                                                              \
    esac                                                                                              \
 && docker --version


# Install Pipework
RUN wget -qO /usr/local/bin/pipework https://raw.githubusercontent.com/jpetazzo/pipework/master/pipework  \
 && chmod +x /usr/local/bin/pipework


# Install Gosu
ENV GOSU_VERSION=1.7
RUN case "${ARCH}" in                                                                                                \
    armv7l|armhf|arm)                                                                                                \
        wget -qO /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-armhf &&  \
        chmod +x /usr/local/bin/gosu;                                                                                \
      ;;                                                                                                             \
    aarch64|arm64)                                                                                                   \
        wget -qO /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-arm64 &&  \
        chmod +x /usr/local/bin/gosu;                                                                                \
      ;;                                                                                                             \
    x86_64|amd64)                                                                                                    \
        wget -qO /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64 &&  \
        chmod +x /usr/local/bin/gosu;                                                                                \
	;;                                                                                                           \
    *)                                                                                                               \
	echo "Unhandled architecture: ${ARCH}."; exit 1;                                                             \
      ;;                                                                                                             \
    esac                                                                                                             \
 && ( gosu --version || true )



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
COPY ./overlay /
RUN systemctl disable docker; systemctl enable docker


# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave

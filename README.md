# Docker image (Debian) on Scaleway


Launch your Docker app on Scaleway servers in minutes.

<img src="http://stratechery.com/wp-content/uploads/2014/12/docker.png" width="400px" />

Alternatively, you now can use [Docker Machine](https://docs.docker.com/machine/) to provision Docker Engine on Scaleway servers, using [docker-machine-driver-scaleway](https://github.com/scaleway/docker-machine-driver-scaleway).

---

## How to hack

**This image is meant to be used on a Scaleway server.**

We use the Docker's building system and convert it at the end to a disk image that will boot on real servers without Docker. Note that the image is still runnable as a Docker container for debug or for inheritance.

[More info](https://github.com/scaleway/image-builder)

---

## Links


- Docker on the C1
  - [Hypriot Blog: Docker on Raspberry PI (compatible with Scaleway)](http://blog.hypriot.com)
  - [Community: Docker Support](https://community.cloud.online.net/t/official-docker-support/374?u=manfred)
  - [Community: Getting started with Docker on C1 (armhf)](https://community.cloud.online.net/t/getting-started-docker-on-c1-armhf/383?u=manfred)
  - [Online Labs Blog - Docker on C1](https://blog.cloud.online.net/2014/10/27/docker-on-c1/)
    - Compatible images for the C1
    - [Docker Hub: "armbuild"](https://hub.docker.com/search/?q=armbuild&page=1&isAutomated=0&isOfficial=0&starCount=0&pullCount=0)
    - [Docker Hub: "hypriot"](https://hub.docker.com/search/?q=hypriot&page=1&isAutomated=0&isOfficial=0&starCount=0&pullCount=0)
    - [Docker Hub: "armhf"](https://hub.docker.com/search/?q=armhf&page=1&isAutomated=0&isOfficial=0&starCount=0&pullCount=0)
- Docker on C1 and/or C2
  - [Maartje Eyskens: Multiarch Docker images](https://eyskens.me/multiarch-docker-images/)

---

A project by [![Scaleway](https://avatars1.githubusercontent.com/u/5185491?v=3&s=42)](https://www.scaleway.com/)

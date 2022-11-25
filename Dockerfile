FROM nvidia/cuda:11.8.0-devel-ubuntu20.04
ARG UID
ARG GID
ARG USER
ARG GROUP
ARG TZ
ENV DEBIAN_FRONTEND noninteractive

RUN groupadd -g $GID $GROUP && useradd -G $GROUP -g $GID -u $UID $USER
RUN apt-get update && apt-get install -y software-properties-common tzdata

COPY ./requirements.txt ./

RUN add-apt-repository ppa:deadsnakes/ppa && apt-get -y install python3.9 python3.9-distutils python3-pip && python3.9 -m pip install -U pip wheel setuptools && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 0
RUN python3.9 -m pip install -r requirements.txt

USER $USER
RUN unset UID GID GROUP
WORKDIR "/home/$USER/app"
ENV TZ $TZ
ENV PYTHONPATH "/home/$USER/app"

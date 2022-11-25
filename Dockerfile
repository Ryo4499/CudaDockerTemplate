FROM nvidia/cuda:11.8.0-devel-ubuntu20.04

ARG HOST_UID
ARG HOST_GID
ARG MY_USER
ARG MY_GROUP
ARG TZ

ENV TZ $TZ
ENV DEBIAN_FRONTEND noninteractive

RUN groupadd -g $HOST_GID $MY_GROUP && useradd -G $MY_GROUP -g $HOST_GID -u $HOST_UID $MY_USER
RUN apt-get update && apt-get install -y software-properties-common tzdata

COPY ./requirements.txt ./

RUN add-apt-repository ppa:deadsnakes/ppa && apt-get -y install python3.9 python3.9-distutils python3-pip && python3.9 -m pip install -U pip wheel setuptools && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 0
RUN python3.9 -m pip install -r requirements.txt

USER $MY_USER

WORKDIR "/home/$MY_USER/app"
ENV PYTHONPATH "/home/$MY_USER/app"

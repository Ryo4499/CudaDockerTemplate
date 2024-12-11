FROM --platform=linux/amd64 nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04

ARG HOST_UID=1000
ARG HOST_GID=1000
ARG HOST_USER='user'
ARG HOST_GROUP='user'
ARG TZ='Asia/Tokyo'
ARG PYTHON_VERSION='3.11'

ENV TZ $TZ
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y sudo \
    pipx \
    tzdata \
    zsh \
    vim \
    software-properties-common && \
    groupadd -g ${HOST_GID} ${HOST_GROUP} && \
    useradd -m -u ${HOST_UID} -g ${HOST_GID} -s /bin/zsh ${HOST_USER} && \
    chown -R ${HOST_USER}:${HOST_GROUP} /home/${HOST_USER} && \
    echo ${HOST_USER} ALL=\(ALL\) NOPASSWD:ALL > /etc/sudoers.d/${HOST_USER} && \
    chmod 0440 /etc/sudoers.d/${HOST_USER} && \
    echo $TZ > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python${PYTHON_VERSION}-full python${PYTHON_VERSION}-dev && \
    update-alternatives --install /usr/bin/python python /usr/bin/python${PYTHON_VERSION} 1 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${PYTHON_VERSION} 1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /home/${HOST_USER}/app

USER ${HOST_USER}

ENV PATH="$PATH:/home/${HOST_USER}/.local/bin" \
    PATH="$PATH:/home/${HOST_USER}/.venv/bin" \
    PATH="$PATH:/home/${HOST_USER}/.local/pipx/venvs/poetry/bin"

RUN pipx ensurepath && \
    pipx install poetry && \
    poetry config virtualenvs.in-project false && \
    poetry config virtualenvs.create true && \
    poetry config cache-dir /tmp/poetry_cache


COPY --chown=${HOST_USER}:${HOST_GROUP} pyproject.toml poetry.lock .

RUN poetry install --no-root

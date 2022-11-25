# CudaDockerTemplate

This is a Cuda Docker Template.  
The container is bind on specified a local machine user by `.env` file.  
Also, this directory bind mount to volumes.  

Environments:

- Python 3.9
- Cuda 11.8

Base Images:

- <https://hub.docker.com/r/nvidia/cuda>

## How to use

```sh
cp .env.sample .env
# Specify your environments
vi .env
docker-compose build
docker-compose up -d
docker-compose down
```

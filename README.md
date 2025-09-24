This system is a dockerized development system for computer vision applications.

## What do I need to use it

You have to have at least cuda 12.4 to run it, and of course docker installed
with the possibility of using GPU.

## How do I use it

First of all set the .env variables. You can also add GID and UID if you want.

You will find a template of those variables at dotenv.template.

Afterwards, just run on a terminal (from the main folder) the following:
```
docker compose up -d
```
and that's it.

You can check if it works by doing:
```
# Check graphical forwarding
docker compose exec dev_service xeyes

# Check GPU
docker compose exec dev_service python -c "import torch;print(f'PyTorch version: {torch.__version__}');print(f'CUDA available: {torch.cuda.is_available()}')"
```

When you finish working, close the container with `docker compose down`and everything is
outside the container in this same folder structure.

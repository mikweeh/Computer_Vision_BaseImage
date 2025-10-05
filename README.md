This system is a dockerized development system for computer vision applications.

## The environment inside

It uses a python 3.11 with cuda 12.4 support. The libraries installed and versions are:
```
torch==2.8.0+cu128
albumentations==2.0.8
debugpy==1.8.17
flake8==7.3.0
hydra-core==1.3.2
imutils==0.5.4
matplotlib==3.10.6
numpy==2.2.6
opencv-python==4.12.0.88
pandas==2.3.2
pillow==11.3.0
pycocotools==2.0.10
pytest==8.4.2
reportlab==4.4.4
scikit-learn==1.7.2
scipy==1.16.2
shap==0.48.0
shapely==2.1.2
streamlit==1.50.0
tensorboard==2.20.0
tqdm==4.67.1
transformers==4.56.2
ultralytics==8.3.203
wandb==0.22.0
```

## What do I need to use it?

You have to have at least cuda 12.4 to run it, and of course docker installed
with the possibility of using GPU.

## Folder Structure

Your development repo should have the following structure:
```
repo
  |___ dataset
  |___ src
  |___ docker-compose.yml
  |___ Dockerfile
  |___ requirements.txt
  |___ .env
```

It may contain other folders or files, but this is the basic setup. Here is what
 each item is for:
```
`dataset`: Empty folder locally, mapped to the dataset specified in the DATASET_PATH environment variable
`src`: Contains all project code.
`docker-compose.yml`: The file used by docker compose to launch the system. Do not modify it.
`Dockerfile`: The file that builds the image. Do not modify it.
`requirements.txt`: Python requirements file. If you need more libraries, add them here.
`.env`: The file where environment variables are defined.
```

## Initial Setup

To implement this setup in a new project, copy the following items to your project folder:

- `docker-compose.yml`
- `Dockerfile`
- `requirements.txt`
- Environment variables file `.env`
- Empty folder named `dataset`
- `src` folder for your code

## Environment Variables

Configure the `.env` file with the following variables:

- `PROJECT_NAME`: Project name that determines the container name.
- `DATASET_PATH`: Path where the dataset is stored on the host (e.g., `/home/azken/bagfiles/CABRERA`). It is mounted as read-only in the container
- `CONTAINER_DISPLAY`: Value of the DISPLAY variable to export images
  - With AnyDesk or local: usually `:1` (or `:0`)
  - With SSH: Use the host IP address with the port you prefer from 15 to 50 (e.g., `172.XX.XX.XX:20`, example choosing port 20). Remember this choice.

You can also add variables `GID` and `UID` if you want.

## Using the Development Environment

To start the environment:
```
$ docker compose up -d
```

This creates the container. Your project folder is mounted at `/home/rosuser/repo` inside the container, and the dataset will be at `/home/rosuser/repo/dataset`. You can debug code step by step with VSCode.

To stop the environment:
```
$ docker compose down -v
```

When the system is stopped, the container is removed, but any changes made are
preserved in the project folder on the host.

If you run the example code at `src/main.py` you should see the figure created with matplotlib in the host screen (this implies that X11 forwarding is working)

Or you can check if it works from outside the container by doing:
```
# Check graphical forwarding
docker compose exec dev_service xeyes

# Check GPU
docker compose exec dev_service python -c "import torch;print(f'PyTorch version: {torch.__version__}');print(f'CUDA available: {torch.cuda.is_available()}')"
```

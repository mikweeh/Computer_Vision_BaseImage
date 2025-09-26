FROM runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04

ARG UID=1000
ARG GID=1000

# Keep Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1
# Turn off buffering for easier container logging
ENV PYTHONUNBUFFERED=1
ENV WORKSPACE=/home/rosuser/repo

# Fix locale configuration
RUN apt-get update && apt-get install -y locales && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set locale environment variables
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US:en

# Working directory
WORKDIR ${WORKSPACE}

# Install system dependencies
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/London
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx libglib2.0-0 \
    libtcl8.6 libtk8.6 tk \
    python3-tk \
    git \
    x11-apps \
    xauth \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install pip requirements (PyTorch already installed)
COPY ./requirements.txt ./
RUN pip install --ignore-installed --no-cache-dir -r requirements.txt

# Copy source code
COPY ./src ./src

# Create user (adapted from your working setup)
RUN if getent group $GID >/dev/null; then \
    existing_group=$(getent group $GID | cut -d: -f1); \
    useradd -m -u $UID -g $existing_group -s /bin/bash rosuser; \
else \
    groupadd -g $GID rosuser && \
    useradd -m -u $UID -g $GID -s /bin/bash rosuser; \
fi

# Set ownership and permissions
RUN chown -R $UID:$GID /home/rosuser

# Switch to non-root user
USER rosuser

# Expose debugging port
EXPOSE 5678

CMD ["python", "src/main.py"]

# docker compose build --no-cache
# docker compose exec dev_service xeyes
# docker compose exec dev_service python -c "import torch;print(f'PyTorch version: {torch.__version__}');print(f'CUDA available: {torch.cuda.is_available()}')"

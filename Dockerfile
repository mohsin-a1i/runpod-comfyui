FROM nvidia/cuda:12.9.1-cudnn-runtime-ubuntu24.04

# Prevents prompts from packages asking for user input during installation
ENV DEBIAN_FRONTEND=noninteractive
# Speed up some cmake builds
ENV CMAKE_BUILD_PARALLEL_LEVEL=8

# Install Python, git and other necessary tools
RUN apt-get update && apt-get install -y \
    curl \
    git \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    ffmpeg

# Clean up to reduce image size
RUN apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install uv python manager
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"

# Install python
RUN uv python install cpython-3.12.12-linux-aarch64-gnu

# Create python venv
RUN uv venv -p cpython-3.12.12-linux-aarch64-gnu

# Configure python venv
ENV PATH="/app/.venv/bin:$PATH"

# Prefer binary wheels over source distributions for faster pip installations
ENV PIP_PREFER_BINARY=1
# Ensures output from python is printed immediately to the terminal without buffering
ENV PYTHONUNBUFFERED=1
# Prevent pip from asking for confirmation during uninstall steps in custom nodes
ENV PIP_NO_INPUT=1

# Upgrade pip / setuptools / wheel
RUN uv pip install --upgrade pip setuptools wheel comfy-cli triton

# Install PyTorch for CUDA 12.9
RUN uv pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu129

# Install SageAttention
COPY wheels/sageattention-2.2.0-cp312-cp312-linux_aarch64.whl wheels/
RUN uv pip install --no-index wheels/sageattention-2.2.0-cp312-cp312-linux_aarch64.whl

# Install Python runtime dependencies for the handler
RUN pip install runpod requests websocket-client

# Install ComfyUI
RUN /usr/bin/yes | comfy --workspace /app/comfyui install --version 0.9.2 --cuda-version 12.9 --nvidia;

# Support for the network volume
COPY src/extra_model_paths.yaml /app/comfyui/

# Copy helper script to switch Manager network mode at container start
COPY scripts/comfy-manager-set-mode.sh /usr/local/bin/comfy-manager-set-mode
RUN chmod +x /usr/local/bin/comfy-manager-set-mode

# Add script to install custom nodes
COPY scripts/comfy-node-install.sh /usr/local/bin/comfy-node-install
RUN chmod +x /usr/local/bin/comfy-node-install

# install custom nodes using comfy-cli
RUN comfy-node-install comfyui-kjnodes comfyui-videohelpersuite ComfyUI-WanVideoWrapper

# Add application code and scripts
ADD src/start.sh src/network_volume.py src/handler.py /app/
RUN chmod +x /app/start.sh

# Set the default command to run when starting the container
CMD ["./start.sh"]


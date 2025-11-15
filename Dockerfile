FROM nvidia/cuda:12.8.0-cudnn-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# Base dependencies
RUN apt-get update && apt-get install -y \
    git build-essential python3-dev python3-pip python3-venv \
    libaio-dev libopenblas-dev wget curl \
    ninja-build software-properties-common lsb-release && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN python3 -m pip install --upgrade pip setuptools wheel

# Install CMake 3.28+
RUN wget https://apt.kitware.com/kitware-archive.sh && \
    bash kitware-archive.sh && \
    apt-get update && apt-get install -y cmake && \
    cmake --version

# Install PyTorch 2.8.0 CUDA 12.8
RUN pip install torch==2.8.0 torchvision torchaudio \
    --extra-index-url https://download.pytorch.org/whl/cu128

# ------------------------
# Build flash-attn (CUDA 12.8)
# ------------------------
RUN git clone https://github.com/Dao-AILab/flash-attention.git /flash-attention \
    && cd /flash-attention \
    && pip install psutil ninja packaging numpy pybind11 \
    && pip install . --no-build-isolation

# ------------------------
# Install vLLM
# ------------------------
RUN git clone https://github.com/vllm-project/vllm.git /vllm
WORKDIR /vllm

RUN pip install "numpy<2" transformers accelerate setuptools_scm

# Build vLLM with CUDA backend
RUN pip install --no-build-isolation -e .

CMD ["tail", "-f", "/dev/null"]

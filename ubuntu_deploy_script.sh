#!/bin/bash

set -e
set -x
# Become root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# install dependencies
if ! command -v cmake &> /dev/null; then
  echo "installing dependencies"
  apt update && apt install -y build-essential cmake mesa-common-dev git wget
else
  echo "dependencies are already installed."
fi

# Check if CUDA toolkit 12.6 is installed
if ! apt list --installed 2>/dev/null | grep -q cuda-toolkit-12-6; then
    echo "CUDA toolkit 12.6 is not installed, proceeding with installation..."

    # Download and install the CUDA keyring package
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.1-1_all.deb
    dpkg -i cuda-keyring_1.1-1_all.deb

    # Update package lists and install CUDA toolkit
    apt update && apt install -y cuda-toolkit-12-6
else
    echo "CUDA toolkit 12.6 is already installed."
fi

# clone quai-gpu-miner
git clone https://github.com/dominant-strategies/quai-gpu-miner
cd quai-gpu-miner
git submodule update --init --recursive
mkdir build && cd build

# configure cmake
cmake .. -DETHASHCUDA=ON -DETHASHCL=ON

# build cmake
cmake --build .

mkdir -p ../../output && cp kawpowminer/kawpowminer ../../output/quai-gpu-miner

# Finish
echo "All tasks completed successfully!"

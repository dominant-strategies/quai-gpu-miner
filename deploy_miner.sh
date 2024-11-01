#!/bin/bash

set -e
set -x
# Become root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Install dependencies
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

echo "All dependencies installed successfully!"

# Clone quai-gpu-miner
git clone https://github.com/dominant-strategies/quai-gpu-miner
cd quai-gpu-miner
git submodule update --init --recursive

# First build with CUDA enabled and OpenCL disabled
mkdir build && cd build
cmake .. -DETHASHCUDA=ON -DETHASHCL=OFF
cmake --build .
mkdir -p ../../output && cp kawpowminer/kawpowminer ../../output/quai-gpu-miner-nvidia

# Copy hiveos_packager for NVIDIA package
cd ../
cp -r hiveos_packager quai-gpu-miner-nvidia
cp ../../output/quai-gpu-miner-nvidia quai-gpu-miner-nvidia/quai-gpu-miner
chmod -R a+rwx quai-gpu-miner-nvidia
tar -zcvf quai-gpu-miner-nvidia.tar.gz quai-gpu-miner-nvidia/
mv quai-gpu-miner-nvidia.tar.gz ../output

# Clean build directory for the second build
rm -rf build && mkdir build && cd build

# Second build with OpenCL enabled and CUDA disabled
cmake .. -DETHASHCUDA=OFF -DETHASHCL=ON
cmake --build .
cp kawpowminer/kawpowminer ../../output/quai-gpu-miner-amd

# Copy hiveos_packager for AMD package
cd ../
cp -r hiveos_packager quai-gpu-miner-amd
cp ../../output/quai-gpu-miner-amd quai-gpu-miner-amd/quai-gpu-miner
chmod -R a+rwx quai-gpu-miner-amd
tar -zcvf quai-gpu-miner-amd.tar.gz quai-gpu-miner-amd/
mv quai-gpu-miner-amd.tar.gz ../output

# Finish
echo "All tasks completed successfully!"

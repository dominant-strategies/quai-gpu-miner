# Use an Ubuntu image or another suitable base image
FROM ubuntu:20.04

# Set environment variables to avoid user interaction during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required dependencies including CUDA
RUN apt update && apt install -y \
    build-essential \
    cmake \
    mesa-common-dev \
    git \
    wget && \
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.1-1_all.deb && \
    dpkg -i cuda-keyring_1.1-1_all.deb && \
    apt update && apt install -y cuda-toolkit-12-6 && \
    rm -rf /var/lib/apt/lists/* /cuda-keyring_1.1-1_all.deb

# Copy your bash script into the container
COPY ubuntu_deploy_script.sh .

# Make the script executable
RUN chmod +x ubuntu_deploy_script.sh

# Run the script to build the binary
CMD ["./ubuntu_deploy_script.sh"]

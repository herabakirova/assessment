# Use an official base image
FROM ubuntu:22.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
    curl \
    unzip \
    wget \
    git \
    gnupg \
    lsb-release \
    ca-certificates \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Docker
RUN curl -fsSL https://get.docker.com | sh

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm awscliv2.zip

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

# Install Terraform
RUN curl -LO "https://releases.hashicorp.com/terraform/1.9.4/terraform_1.9.4_linux_amd64.zip" && \
    unzip terraform_1.9.4_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_1.9.4_linux_amd64.zip

# Set up the working directory
WORKDIR /workspace

# Add a default command
CMD ["sleep", "infinity"]


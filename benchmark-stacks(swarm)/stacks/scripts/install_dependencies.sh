#!/bin/bash

# Configuration
NOMAD_VERSION="1.11.1"
CONSUL_VERSION="1.22.3"
ENVOY_VERSION="1.32.2"

echo "Checking dependencies installation..."

# Function to check if a command exists and its version
check_version() {
    local cmd=$1
    local expected=$2
    if command -v "$cmd" >/dev/null 2>&1; then
        local current_version=$("$cmd" version 2>&1 | head -n 1)
        echo "✅ $cmd is already installed: $current_version"
        return 0
    else
        echo "❌ $cmd is not installed."
        return 1
    fi
}

# Special check for Envoy
check_envoy() {
    if command -v envoy >/dev/null 2>&1; then
        local v=$(envoy --version | head -n 1)
        echo "✅ envoy is already installed: $v"
        return 0
    else
        echo "❌ envoy is not installed."
        return 1
    fi
}

INSTALL_NEEDED=false

if ! check_version "nomad" "$NOMAD_VERSION"; then INSTALL_NEEDED=true; fi
if ! check_version "consul" "$CONSUL_VERSION"; then INSTALL_NEEDED=true; fi
if ! check_envoy; then INSTALL_NEEDED=true; fi

if [ "$INSTALL_NEEDED" = false ]; then
    echo "All services are already installed. Skipping installation."
    exit 0
fi

echo "Proceeding with installation..."

# Install base dependencies
sudo apt-get update && sudo apt-get install -y gpg coreutils curl

# 1. Install HashiCorp Nomad & Consul
if ! command -v nomad >/dev/null 2>&1 || ! command -v consul >/dev/null 2>&1; then
    echo "Adding HashiCorp repository..."
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt-get update && sudo apt-get install -y nomad consul
fi

# 2. Install Envoy
if ! command -v envoy >/dev/null 2>&1; then
    echo "Adding Envoy repository..."
    sudo curl -L https://getenvoy.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/getenvoy-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/getenvoy-keyring.gpg] https://dl.bintray.com/tetrate/getenvoy-deb $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/getenvoy.list
    sudo apt-get update && sudo apt-get install -y getenvoy-envoy
fi

echo "Installation complete."
nomad version
consul version
envoy --version

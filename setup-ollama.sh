#!/bin/bash
sudo mkdir /opt/ollama
sudo chown $USER:$USER /opt/ollama
cd /opt/ollama
curl -fsSL https://ollama.com/install.sh >install.sh
chmod +x install.sh
sudo ./install.sh

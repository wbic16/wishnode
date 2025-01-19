#!/bin/bash
if [ -d /usr/share/ollama ]; then
  cd /usr/share/ollama
  if [ ! -f /usr/share/ollama/.ollama/models/manifests/registry.ollama.ai/library/tinyllama/latest ]; then
    echo "Initializing tinyllama..."
    scp wbic16@logos-prime:/home/wbic16/ollama-init.tar ollama-init.tar
    tar xvf ollama-init.tar
  fi
fi

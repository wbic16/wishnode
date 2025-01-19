#!/bin/bash
if [ -d /usr/share/ollama ]; then
  cd /usr/share/ollama
  if [ ! -d .ollama ]; then
    echo "Initializing tinyllama..."
    scp wbic16@logos-prime:/home/wbic16/ollama-init.tar ollama-init.tar
    tar xvf ollama-init.tar
  fi
fi

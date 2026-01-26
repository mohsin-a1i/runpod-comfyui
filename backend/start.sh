#!/usr/bin/env bash

# Use libtcmalloc for better memory management
TCMALLOC="$(ldconfig -p | grep -Po "libtcmalloc.so.\d" | head -n 1)"
export LD_PRELOAD="${TCMALLOC}"

if [ -n "$PUBLIC_KEY" ]; then
    mkdir -p /root/.ssh
    chmod 700 /root/.ssh

    echo "$PUBLIC_KEY" > /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys

    mkdir -p /var/run/sshd
    exec /usr/sbin/sshd -D

    echo "SSH access configured."
fi

python comfyui/main.py \
    --fast fp16_accumulation \
    --use-sage-attention \
    --listen 
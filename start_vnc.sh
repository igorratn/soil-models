#!/bin/bash

# Set the VNC password
mkdir -p ~/.vnc
echo "password" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

# Start the VNC server
tightvncserver :1 -geometry 1280x800 -depth 24 -dpi 96
sleep 5

# Start noVNC using websockify with the correct Python interpreter
/opt/novnc/utils/websockify/venv/bin/python /opt/novnc/utils/websockify/venv/bin/websockify --web /opt/novnc 6080 localhost:5901
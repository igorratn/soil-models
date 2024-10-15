# Use an official Ubuntu as a parent image
FROM ubuntu:latest

# Update the package list and install necessary packages
RUN apt-get update && apt-get install -y \
    dosbox \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    wget \
    python3 \
    python3-pip \
    python3-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /soil-models

# Copy the local src directory to the container
COPY src /soil-models/src

# Copy the local dosbox-0.74-3.conf file to the container
COPY dosbox-0.74-3.conf /root/.dosbox/dosbox-0.74-3.conf

# Set the USER environment variable
ENV USER=root

# Set up the VNC server
RUN mkdir -p ~/.vnc && \
    echo "#!/bin/sh\nstartxfce4 &\ndosbox" > ~/.vnc/xstartup && \
    chmod +x ~/.vnc/xstartup

# Install noVNC and websockify
RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.3.0.tar.gz && \
    tar -xzf v1.3.0.tar.gz && \
    mv noVNC-1.3.0 /opt/novnc && \
    wget https://github.com/novnc/websockify/archive/refs/tags/v0.9.0.tar.gz && \
    tar -xzf v0.9.0.tar.gz && \
    mv websockify-0.9.0 /opt/novnc/utils/websockify

# Create a virtual environment and install Python dependencies for websockify
RUN python3 -m venv /opt/novnc/utils/websockify/venv && \
    /opt/novnc/utils/websockify/venv/bin/pip install --upgrade pip && \
    /opt/novnc/utils/websockify/venv/bin/pip install numpy websockify

# Verify the installation of websockify by running a simple command
RUN /opt/novnc/utils/websockify/venv/bin/websockify --help

# Create the start_vnc.sh script to set VNC password and start services
COPY start_vnc.sh /usr/local/bin/start_vnc.sh
RUN chmod +x /usr/local/bin/start_vnc.sh

# Expose the VNC and noVNC ports
EXPOSE 5901 6080

# Start the VNC server and noVNC
CMD ["/usr/local/bin/start_vnc.sh"]
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai
ENV PUID=1000
ENV PGID=29 
#PGID=29 for audio:x:29

# Install dependencies
RUN apt-get update && apt-get install -y \
    bluez \
    pulseaudio \
    pulseaudio-module-bluetooth \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user and group
RUN groupadd -g ${PGID} audio && \
    useradd -u ${PUID} -g audio -m -s /bin/bash bluezuser && \
    usermod -aG bluetooth bluezuser

# Create FIFO pipe directory and set permissions
RUN mkdir -p /audio && \
    chown bluezuser:audio /audio && \
    chmod 770 /audio

# Copy Bluetooth configuration script
COPY bluez-config.sh /bluez-config.sh
RUN chmod +x /bluez-config.sh && \
    chown bluezuser:audio /bluez-config.sh

# Switch to non-root user
USER bluezuser

# Run Bluetooth daemon and configuration script
CMD ["/bin/bash", "-c", "/bluez-config.sh && bluetoothd --nodetach"]
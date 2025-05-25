FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai
ENV PUID=1000
ENV PGID=1000

# Install dependencies
RUN apt-get update && apt-get install -y \
    bluez \
    pulseaudio \
    pulseaudio-module-bluetooth \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create audio and bluetooth groups, avoiding conflicts
RUN if getent group ${PGID} > /dev/null; then \
        groupmod -n audio $(getent group ${PGID} | cut -d: -f1); \
    else \
        groupadd -g ${PGID} audio; \
    fi && \
    groupadd -r bluetooth || true

# Create non-root user
RUN if getent passwd ${PUID} > /dev/null; then \
        usermod -g audio -s /bin/bash $(getent passwd ${PUID} | cut -d: -f1); \
    else \
        useradd -u ${PUID} -g audio -m -s /bin/bash bluezuser; \
    fi && \
    usermod -aG bluetooth bluezuser || true

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
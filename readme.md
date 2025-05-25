## Introduction
This is a docker which used for snapcast integration, the function of it used to control bluetooh device. the main idea from https://medium.com/omi-uulm/how-to-run-containerized-bluetooth-applications-with-bluez-dced9ab767f6 and code from grok AI, thanks for the great AI.

## Docker build 
The docker build image with multiple platforms, like amd64,arm64,armv6, armv7,mips, purpose to make it could be used on all raspberry, mips,X86 hardware.

## Usage
I prefer to use docker-compose to deploy service to reduce the work of deplyment and imigration.
```yml
  bluez:
    image: custom/bluez:arm64
    container_name: bluez
    volumes:
      - /tmp/snapfifo_bluetooth:/audio/snapfifo_bluetooth
      - ./bluez-config.sh:/bluez-config.sh
    devices:
      - /dev/snd:/dev/snd
      - /dev/bus/usb:/dev/bus/usb # For Bluetooth USB dongle
    cap_add:
      - NET_ADMIN # For Bluetooth network operations
    environment:
      - PUID=1000
      - PGID=29 # Replace with your host's audio group ID
    networks:
      macvlan_net:
        ipv4_address: 192.168.1.104 # Static IP for bluez
    restart: unless-stopped

## Limitation
Currently unknow

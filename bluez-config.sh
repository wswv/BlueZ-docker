#!/bin/bash
# Configure Bluetooth to output to Snapcast FIFO
pactl load-module module-bluetooth-discover
pactl load-module module-bluetooth-policy
pactl load-module module-pipe-sink file=/audio/snapfifo_bluetooth sink_name=bluetooth format=s16le rate=48000 channels=2
sleep infinity
#!/bin/bash

/usr/sbin/sshd &
/usr/sbin/mosquitto -c /etc/mosquitto/mosquitto.conf &
mosquitto &
Hostname -I
node-red &
/usr/bin/python /etc/busapp/busapp.py

#!/bin/bash

/usr/sbin/sshd &
/usr/sbin/mosquitto -c /etc/mosquitto/mosquitto.conf &
mosquitto
node-red &
/usr/bin/python /etc/busapp/busapp.py

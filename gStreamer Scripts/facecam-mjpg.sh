#!/bin/sh
OBSIP=192.168.1.61
CAMERA=/dev/video0
PORT=8557

gst-launch-1.0 v4l2src device=$CAMERA ! queue !'image/jpeg, width=1920, height=1080, framerate=60/1, format=MJPG' ! jpegparse ! rtpjpegpay ! udpsink host=$OBSIP port=$PORT sync=false ts-offset=0 max-lateness=-1

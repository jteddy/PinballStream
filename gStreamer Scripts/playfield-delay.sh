#!/bin/sh
OBSIP=192.168.1.61
CAMERA=/dev/video4
PORT=8555
WIDTH=1280
HEIGHT=720
FRAMERATE=60
DELAY=55

gst-launch-1.0 -v -e v4l2src device=$CAMERA ! image/jpeg,width=$WIDTH,height=$HEIGHT,framerate=$FRAMERATE/1 ! jpegparse ! queue max-size-buffers=$DELAY ! rtpjpegpay ! udpsink host=$OBSIP port=$PORT sync=false ts-offset=0 max-lateness=-1

OBSIP=192.168.0.184
CAMERA=/dev/video0
PORT=8556
WIDTH=800
HEIGHT=448
FRAMERATE=30
# REMOVED
## queue max-size-time=9000000000 leaky=2

gst-launch-1.0 -v -e v4l2src device=$CAMERA ! queue ! video/x-h264,width=$WIDTH,height=$HEIGHT,framerate=$FRAMERATE/1 ! h264parse ! rtph264pay ! udpsink host=$OBSIP port=$PORT sync=false ts-offset=0 max-lateness=-1

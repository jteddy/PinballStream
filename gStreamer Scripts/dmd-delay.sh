OBSIP=192.168.1.61
CAMERA=/dev/video10
PORT=8556
WIDTH=800
HEIGHT=448
FRAMERATE=30

gst-launch-1.0 -v -e v4l2src device=$CAMERA ! queue max-size-time=9000000000 leaky=2 ! video/x-h264,width=$WIDTH,height=$HEIGHT,framerate=$FRAMERATE/1 ! h264parse ! rtph264pay ! udpsink host=$OBSIP port=$PORT sync=false ts-offset=0 max-lateness=-1

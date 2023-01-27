OBSIP=192.168.1.61
SOUNDPORT=8456

gst-launch-1.0 -v -e alsasrc device=hw:3,0 ! audioconvert ! audioresample ! opusenc ! rtpopuspay ! udpsink host=$OBSIP port=$SOUNDPORT sync=false ts-offset=0 max-lateness=-1

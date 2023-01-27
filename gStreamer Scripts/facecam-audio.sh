OBSIP=192.168.1.61
SOUNDPORT=8455

gst-launch-1.0 -v -e alsasrc device=hw:1,0 ! audioconvert ! audioresample ! opusenc ! rtpopuspay ! udpsink host=$OBSIP port=$SOUNDPORT sync=false ts-offset=0 max-lateness=-1

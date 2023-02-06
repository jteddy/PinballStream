OBSIP=192.168.0.184
SOUNDPORT=8455

gst-launch-1.0 -v -e alsasrc device=hw:3,0 ! audioconvert ! audioresample ! opusenc ! rtpopuspay ! udpsink host=$OBSIP port=$SOUNDPORT sync=false ts-offset=0 max-lateness=-1

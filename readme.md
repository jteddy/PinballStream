# Wireless Streaming

- C920 - DMD
- Logitech Bio - Playfield
- Pete's CamCorder - Player Face
- GoPro - Venue Cam
- Commentators Camera - ???

## USB Interface Standards

| Interface                       | Realistic Speed |
| ------------------------------- | --------------- |
| USB 2.0                         | 35 Mbyte/s      |
| USB 3.0 Super Speed (3.1 Gen 1) | 300 MB/s        |
| USB 3.1 Gen 2                   | 900 MB/s        |
| Thunderbolt 3                   | 40 GBit/s       |

## Cameras Review

| Camera            | Max Res                 | Bandwidth | Interface             | RRP  |
| ----------------- | ----------------------- | --------- | ---------             | ---- |
| Logitech C920     | 1080p30 / 720p30        |           | USB-A                 |      |
| Logitech C922 Pro | 1080p30 / 720p60        |           | USB-A                 |      |
| Logitech Brio 4k  | 4k30 / 1080p60 / 720p90 |           | USB-C                 |      |
| Elgato Facecam    | 1080p60 / 720p60        |           |                       |      |
| Sony CX-405       | 1080p (50p-AU version)  |           | Mini-HDMI to HDMI/USB | $280 |

## Small Form Factor PCs

| Model |                          | Eth  | Wifi     |
| ----- | ------------------------ | ---- | -------- |
| Pi 4  | USB 2 - 2<br />USB 3 - 2 | Gig  | 802.11ac |



## Tech
## GStreamer Windows Setup
https://cosmostreamer.com/wiki/index.php?title=OBS_Gstreamer_plugin

Windows USB Device Tree
https://www.uwe-sieber.de/usbtreeview_e.html#download

## Ubuntu Build

```bash
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y openssh-server sudo adduser
sudo adduser pinball sudo
sudo systemctl status ssh
```

**Install Packages**
```bash
sudo apt-get install -y gstreamer1.0*
sudo apt-get install -y libgstreamer*
sudo apt-get install -y ges*
sudo apt-get install -y v4l*
sudo apt-get install -y h264enc
sudo apt-get install libopenh264-6 libopenh264-dev
```

**Errors**
```
sudo apt-get install $(apt-cache --names-only search ^gstreamer1.0-* | awk '{print $1}' | grep -v gstreamer1.0-hybris | grep -v gstreamer1.0-python3-dbg-plugin-loader)
```

## GStreamer with OSX
## Installation
- Install XCode
- Install brew
```
brew install gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-rtsp-server gst-devtools gst-libav gst-plugins-rs ffmpeg gst-ffmpeg
```

export PATH=$PATH:/Library/Frameworks/GStreamer.framework/Versions/1.0/bin 

# Gsteamer
**List Devices**
```
v4l2-ctl --list-devices
```
**List Supported Formats**
```
v4l2-ctl --list-formats
```
**List Supported Format Extensions**
```
v4l2-ctl --list-formats-ext
```

# Logitech C920 - DMD Camera
**Codec:** h264
**Resolution:** 320x240


```
v4l2-ctl --list-devices
v4l2-ctl --device /dev/video4
v4l2-ctl --device /dev/video4 --list-formats
v4l2-ctl --device /dev/video4 --list-formats-ext
```

**Test Web Cam Command**
```
gst-launch-1.0 -v -e v4l2src device=/dev/video4 ! queue ! video/x-h264,width=320,height=240,framerate=30/1 ! h264parse ! avdec_h264 ! xvimagesink sync=false
```

**RTP Unicast**
```
 gst-launch-1.0 -v udpsrc port=4000 caps='application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264'-e v4l2src device=/dev/video4 ! queue ! video/x-h264,width=320,height=240,framerate=30/1 ! h264parse ! avdec_h264 ! xvimagesink sync=false
 
 
 gst-launch -v udpsrc port=4000 caps='application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264' ! 
          rtph264depay ! ffdec_h264 ! xvimagesink sync=false
          
```


# Appendix
## Resources
- https://oz9aec.net/software/gstreamer/using-the-logitech-c920-webcam-with-gstreamer-12

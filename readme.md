**Table of Contents**

[TOCM]

# Camera Summary

## USB Interface Standards

| Interface                       | Realistic Speed |
| ------------------------------- | --------------- |
| USB 2.0                         | 35 Mbyte/s      |
| USB 3.0 Super Speed (3.1 Gen 1) | 300 MB/s        |
| USB 3.1 Gen 2                   | 900 MB/s        |
| Thunderbolt 3                   | 40 GBit/s       |

## Cameras Review

| Camera             | Max Res                 | Codec | Interface             | RRP  |
| ------------------ | ----------------------- | ----- | --------------------- | ---- |
| Logitech C920      | 1080p30 / 720p30        |       | USB-A                 |      |
| Logitech C922 Pro  | 1080p30 / 720p60        |       | USB-A                 |      |
| Logitech Brio 4k   | 4k30 / 1080p60 / 720p90 |       | USB-C                 |      |
| Elgato Facecam     | 1080p60 / 720p60        |       |                       |      |
| Sony CX-405        | 1080p50 AU version      |       | Mini-HDMI to HDMI/USB | $280 |
| GoPro Hero Black 7 |                         |       |                       |      |

# Software Installation

## GStreamer Windows Setup for OBS

- [OBS Gstreamer Plugin for Windows](https://cosmostreamer.com/wiki/index.php?title=OBS_Gstreamer_plugin)

If you are using gstreamer on a Windows platform [Windows USB Device Tree](https://www.uwe-sieber.de/usbtreeview_e.html#download) will be able to find the device ID for you.

## Ubuntu Build

```bash
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y openssh-server sudo adduser
sudo adduser pinball sudo
sudo systemctl status ssh
```

### Install Packages

```bash
sudo apt-get install -y gstreamer1.0*
sudo apt-get install -y libgstreamer*
sudo apt-get install -y ges*
sudo apt-get install -y v4l*
sudo apt-get install -y h264enc
sudo apt-get install -y libopenh264-6 libopenh264-dev
sudo apt-get install -y ubuntu-restricted-extras screen stacer htop guvcview gnome-tweaks

sudo apt-get install xfonts-75dpi
sudo apt-get install xfonts-100dpi
sudo apt-get install gnome-panel
sudo apt-get install metacity
sudo apt-get install light-themes
```
#### Troubleshooting

If you receive any errors during the install try

```bash
sudo apt-get install $(apt-cache --names-only search ^gstreamer1.0-* | awk '{print $1}' | grep -v gstreamer1.0-hybris | grep -v gstreamer1.0-python3-dbg-plugin-loader)
```
### Disable Power Saving Modes

Turn off any power saving and sleep modes.

```bash
sudo vi  /etc/systemd/logind.conf

#HandleLidSwitch=ignore
#HandleLidSwitchExternalPower=ignore
#HandleLidSwitchDocked=ignore
```

```bash
sudo vi /etc/default/acpi-support
SUSPEND_METHODS="dbus-pm dbus-hal pm-utils"
```
Change to

```bash
SUSPEND_METHODS="none"
sudo /etc/init.d/acpid restart
```

Use gnome-tweaks as there is an option there to disable it. This required a reboot

### Remote Desktop with VNC

```bash
sudo apt install tightvncserver
sudo apt install xfce4 xfce4-goodies
vncserver
vncpasswd
```

```
cat > ~/.vnc/xstartup
```

```
#!/bin/sh

unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

export XKL_XMODMAP_DISABLE=1
export XDG_CURRENT_DESKTOP="GNOME-Flashback:GNOME"
export XDG_MENU_PREFIX="gnome-flashback-"


[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
xsetroot -solid grey
vncconfig -iconic &

gnome-session --builtin --session=gnome-flashback-metacity --disable-acceleration-check --debug &
nautilus &
gnome-terminal &

```
```
sudo chmod +x ~/.vnc/xstartup
```

**Start VNC As A service**

```
sudo nano /etc/systemd/system/vncserver.service
```


```
[Unit]
Description=TightVNC server
After=syslog.target network.target

[Service]
Type=forking
User=jason
Group=jason
WorkingDirectory=/home/jason

#PAMName=login
PIDFile=/home/jason/.vnc/%H:1.pid
ExecStartPre=-/usr/bin/vncserver -kill :1 > /dev/null 2>&1
ExecStart=/usr/bin/vncserver -depth 24 -geometry 1280x1024
ExecStop=/usr/bin/vncserver -kill :1

[Install]
WantedBy=multi-user.target

```

```
sudo systemctl daemon-reload
sudo systemctl enable --now vncserver
sudo systemctl status vncserver
```

**Kill a session**

vncserver -kill :1

### Ubuntu Firewall

```bash
sudo ufw status
sudo ufw disable
```

# Camera Controls
```
v4l2-ctl -d /dev/video10 --list-ctrls
v4l2-ctl --device /dev/video10 --set-ctrl=pan_absolute=7000


```

## GStreamer OSX Setup

### Installation

- Install XCode

- Install brew

  ```
  brew install gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-rtsp-server gst-devtools gst-libav gst-plugins-rs ffmpeg gst-ffmpeg
  ```

export PATH=$PATH:/Library/Frameworks/GStreamer.framework/Versions/1.0/bin

# Gsteamer CLI

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
v4l2-ctl -d /dev/video6 --list-formats-ext |less
```
## YUYV 30fps

**Devices**

- Tested with GoPro Hero Black 7 and a cheap USB Capture Card. 

**Test Command**

```bash
gst-launch-1.0 -v -e v4l2src device=/dev/video4 ! video/x-raw,format=YUY2,width=640,height=480,framerate=30/1 ! videoconvert ! autovideosink
```

**Server / Encoder** (H265)

```bash
#!/bin/sh
OBSIP=192.168.1.61
CAMERA=/dev/video4
PORT=8555

gst-launch-1.0 -v -e v4l2src device=$CAMERA ! video/x-raw,format=YUY2,width=640,height=480,framerate=30/1 ! videoconvert ! x265enc ! h265parse ! rtph265pay ! udpsink host=$OBSIP port=$PORT
```

**Client / Decoder / OBS** (H265)

```bash
udpsrc port=8555 caps = "application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H265, payload=(int)96" ! rtph265depay ! h265parse ! avdec_h265 ! video.
```
### Nvidia Encoding
This command will display information about the NVIDIA GPU(s) installed on your machine, including the driver version, GPU core and memory clocks, and GPU utilization.
```
nvidia-smi
lsmod | grep nvidia
```

- See if your GPU supports the NVENC
  - https://developer.nvidia.com/video-encode-and-decode-gpu-support-matrix-new#Encoder

```bash
#!/bin/sh
OBSIP=192.168.1.61
CAMERA=/dev/video4
PORT=8555

gst-launch-1.0 -v -e v4l2src device=$CAMERA ! video/x-raw,format=YUY2,width=640,height=480,framerate=30/1 ! videoconvert ! nvv4l2h264enc ! h264parse ! rtph264pay ! udpsink host=$OBSIP port=$PORT
```

## GoPro (MJPG)

The quality of a YUY2 stream @ 30 FPS was to poor. This is partly due to the USB capture device. Testing using MJPG

```bash
v4l2-ctl --list-devices
v4l2-ctl --device /dev/video0 --list-formats
v4l2-ctl --device /dev/video0 --list-formats-ext | less
```

Supported Resolutions

- 1920x1080 @ 30
- 1600x1200 @ 30
- 1360x768 @ 30
- 1280x1024 @ 30
-  1280x960 @ 50
- 1280x720 @ 60
- 1024x768 @ 60
- 800x600 @ 60
- 720x576 @60
- 720x480 @ 60
- 640x480 @ 60

gstreamer script

```bash
#!/bin/sh
OBSIP=192.168.1.61
CAMERA=/dev/video2
PORT=8555
WIDTH=1920
HEIGHT=1080
FRAMERATE=30

gst-launch-1.0 -v -e v4l2src device=$CAMERA ! image/jpeg,width=$WIDTH,height=$HEIGHT,framerate=$FRAMERATE/1 ! jpegparse ! rtpjpegpay ! udpsink host=$OBSIP port=$PORT sync=false ts-offset=0 max-lateness=-1

```

## Logitech Brio

In this setup was used for the facecam in portrait mode.

```bash
#!/bin/sh
OBSIP=192.168.1.61
CAMERA=/dev/video2
PORT=8557

gst-launch-1.0 v4l2src device=$CAMERA ! queue !'image/jpeg, width=1920, height=1080, framerate=60/1, format=MJPG' ! jpegparse ! rtpjpegpay ! udpsink host=$OBSIP port=$PORT sync=false ts-offset=0 max-lateness=-1

```

OBS Clinet

```
udpsrc port=8557 caps = "application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)JPEG, payload=(int)26" !  rtpjpegdepay ! jpegparse ! jpegdec ! video.
```



## Logitech C920 - DMD Camera

**Codec:** h264 **Resolution:** 320x240

```
v4l2-ctl --list-devices
v4l2-ctl --device /dev/video4
v4l2-ctl --device /dev/video4 --list-formats
v4l2-ctl --device /dev/video4 --list-formats-ext
```

### H264 Resolutions

| Resolution | FPS  |
| ---------- | ---- |
| 640x360    | 30   |
| 640x480    | 30   |
| 800x448    | 30   |
| 800x600    | 30   |
| 864x480    | 30   |
| 960x720    | 30   |
| 1024x576   | 30   |
| 1280x720   | 30   |
| 1600x896   | 30   |
| 1920x1080  | 30   |

**Test Web Cam Command**

```
gst-launch-1.0 -v -e v4l2src device=/dev/video4 ! queue ! video/x-h264,width=320,height=240,framerate=30/1 ! h264parse ! avdec_h264 ! xvimagesink sync=false
```

**RTP Unicast**

```
 gst-launch-1.0 -v udpsrc port=50001 caps='application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264'-e v4l2src device=/dev/video4 ! queue ! video/x-h264,width=320,height=240,framerate=30/1 ! h264parse ! avdec_h264 ! xvimagesink sync=false          
 
```

**Production Command**

```bash
OBSIP=192.168.1.61
CAMERA=/dev/video10
PORT=8556
WIDTH=800
HEIGHT=448
FRAMERATE=30

gst-launch-1.0 -v -e v4l2src device=$CAMERA ! queue ! video/x-h264,width=$WIDTH,height=$HEIGHT,framerate=$FRAMERATE/1 ! h264parse ! rtph264pay ! udpsink host=$OBSIP port=$PORT sync=false ts-offset=0 max-lateness=-1

```



# OBS Gstreamer

## Installing the Plugin on Windows

https://cosmostreamer.com/wiki/index.php?title=OBS_Gstreamer_plugin

## Pipeline

**C920 WebCam** udpsrc port=50001 ! application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264 ! rtph264depay ! avdec_h264 output-corrupt=false ! videoconvert ! video.

```
gst-launch-1.0 tcpclientsrc host=192.168.1.80 port=50001 ! application/x-rtp-stream,encoding-name=JPEG ! rtpstreamdepay ! rtpjpegdepay ! jpegdec ! autovideosink
gst-launch-1.0 tcpclientsrc host=192.168.1.80 port=50001 ! application/x-rtp-stream,encoding-name=JPEG ! rtpstreamdepay ! rtpjpegdepay ! jpegdec ! autovideosink
```

## C920 RTSP Stream

**H264 Server (encoder)**

```
gst-launch-1.0 -v -e v4l2src device=/dev/video4 ! queue ! video/x-h264,width=320,height=240,framerate=30/1 ! h264parse ! rtph264pay ! udpsink host=192.168.1.54 port=8554 sync=false
```

**H264 Client (decoder / OBS)**

```
udpsrc port=8554 caps = "application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264, payload=(int)96" !  rtph264depay ! h264parse ! avdec_h264 ! video.
```

# Logitech Brio RTSP

The Logitech Brio only supports 60 FPS with MJPG **Test Web Cam**

```
gst-launch-1.0 v4l2src device=/dev/video6  'image/jpeg, width=1920, height=1080, framerate=60/1, format=MJPG' ! jpegdec ! xvimagesink
```

**Logitech Brio - RTSP Stream - Server (encoder)**

```
gst-launch-1.0 v4l2src device=/dev/video6 ! queue !'image/jpeg, width=1920, height=1080, framerate=60/1, format=MJPG' ! jpegparse ! rtpjpegpay ! udpsink host=192.168.1.54 port=8555
```

**Logitech Brio - RTSP Stream - Client (decoder / OBS)**

```
udpsrc port=8555 caps = "application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)JPEG, payload=(int)26" !  rtpjpegdepay ! jpegparse ! jpegdec ! video.
```

## YUYV 30fps


# OBS Configs

## Brio - MJPG

```
udpsrc port=8555 caps = "application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)JPEG, payload=(int)26" !  rtpjpegdepay ! jpegparse ! jpegdec ! video.
```

## Brio - H265

```
udpsrc port=8555 caps="application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H265, payload=(int)96" ! rtph265depay ! h265parse ! avdec_h265 ! video.
```

## Brio - H264

```
udpsrc port=8555 caps="application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264, payload=(int)96" ! rtph264depay ! h264parse ! avdec_h264 ! video.
```

## C920

```
udpsrc port=8554 caps = "application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264, payload=(int)96" !  rtph264depay ! h264parse ! avdec_h264 ! video.
```

# Appendix

## Resources

- https://oz9aec.net/software/gstreamer/using-the-logitech-c920-webcam-with-gstreamer-12
- [Gstreamer udpsrc](https://gstreamer.freedesktop.org/documentation/udp/udpsrc.html?gi-language=c)

\###Sequence Diagram

```seq
Andrew->China: Says Hello 
Note right of China: China thinks\nabout it 
China-->Andrew: How are you? 
Andrew->>China: I am good thanks!
```

\###End

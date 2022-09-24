# Wireless Streaming

## USB Interface Standards

| Interface                       | Realistic Speed |
| ------------------------------- | --------------- |
| USB 2.0                         | 35 Mbyte/s      |
| USB 3.0 Super Speed (3.1 Gen 1) | 300 MB/s        |
| USB 3.1 Gen 2                   | 900 MB/s        |
| Thunderbolt 3                   | 40 GBit/s       |

## Logitech Cameras

| Camera            | Max Res                 | Bandwidth | Interface | RRP  |
| ----------------- | ----------------------- | --------- | --------- | ---- |
| Logitech C920     | 1080p30 / 720p30        |           |           |      |
| Logitech C922 Pro | 1080p30 / 720p60        |           |           |      |
| Logitech Brio 4k  | 4k30 / 1080p60 / 720p90 |           | USB-C     |      |
| Elgato Facecam    | 1080p60 / 720p60        |           |           |      |
| Sony CX-405       |                         |           |           | $280 |

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
``bash
sudo apt-get install -y gstreamer1.0*
sudo apt-get install -y libgstreamer*
sudo apt-get install -y ges*
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

**Test Gstreamer**

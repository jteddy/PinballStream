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



## Debian Build

```bash
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y openssh-server sudo adduser
sudo adduser jt sudo
sudo systemctl status ssh

apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio
```



Errors

```
sudo apt-get install $(apt-cache --names-only search ^gstreamer1.0-* | awk '{print $1}' | grep -v gstreamer1.0-hybris | grep -v gstreamer1.0-python3-dbg-plugin-loader)
```

# GStreamer with OSX

## Installation
```
brew install gstreamer gst-plugins-base gst-plugins-good gst-rtsp-server gst-devtools gst-plugins-bad gst-libav
```

## Command Line
**Gstreamer Test**
```

```

**GStreamer List Devices**

> This is fork of [jaymoulin/docker-rpi-jdownloader](https://github.com/jaymoulin/docker-rpi-jdownloader)
>
> Adds OpenVPN client to protect your privacy.
> Inspired by [haugene/docker-transmission-openvpn](https://github.com/haugene/docker-transmission-openvpn) and [dperson/openvpn-client](https://github.com/dperson/openvpn-client).

---

![logo](logo.png "logo")

Raspberry PI - JDownloader - Docker Image
=

This image allows you to have JDownloader daemon installed easily thanks to Docker.

Build Docker image
---

```
git clone https://github.com/hranicka/docker-rpi-jdownloader.git
cd docker-rpi-jdownloader
docker image build . -t hranicka/rpi-jdownloader
```

Installation
---

```
docker run -d \
    --name jdownloader \
    --restart=always \
    --cap-add=NET_ADMIN \
    --device=/dev/net/tun \
    --dns 8.8.4.4 \
    -v ~/Downloads/jdownloader:/root/Downloads \
    -v ~/jdownloader/cfg:/opt/jdownloader/cfg \
    -v ~/jdownloader/vpn:/etc/openvpn \
    hranicka/rpi-jdownloader
```

This approach expects to have these directories on host machine:

* `~/Downloads` - folder you want download files to
* `~/jdownloader/cfg` - JDownloader configuration files
* `~/jdownloader/vpn` - VPN configuration files

Configuration
---

You have to configure your MyJDownloader login/password with this command :

```
docker exec jdownloader configure <email> <password>
```

Everything else can be configurable on your MyJDownloader account : https://my.jdownloader.org/index.html#dashboard

VPN
---

You can configure VPN by this command :

```
docker exec jdownloader configure-vpn <config file> <auth file>
```

Keep in mind you have `/etc/openvpn` mounted volume and have to place your config and auth files there.

Appendixes
---

### Install RaspberryPi Docker

If you don't have Docker installed yet, you can do it easily in one line using this command
 
```
curl -sSL "https://gist.githubusercontent.com/jaymoulin/e749a189511cd965f45919f2f99e45f3/raw/0e650b38fde684c4ac534b254099d6d5543375f1/ARM%2520(Raspberry%2520PI)%2520Docker%2520Install" | sudo sh && sudo usermod -aG docker $USER
```

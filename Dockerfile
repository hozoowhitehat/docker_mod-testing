# Tambahkan user ke grup sudo dan audio
sudo usermod -aG sudo $USER
sudo usermod -aG audio $USER

# Konfigurasi suara
pactl set-default-sink 0
pactl set-default-source 0

# Pasang wallpaper
wget -O ~/wallpaper.jpg "https://c4.wallpaperflare.com/wallpaper/702/677/218/anime-anime-girls-sword-red-fan-art-hd-wallpaper-preview.jpg"
gsettings set org.gnome.desktop.background picture-uri "file:///home/$USER/wallpaper.jpg"

echo "Memulai instalasi aplikasi..."
sudo apt update -y
clear

# Instalasi aplikasi yang diperlukan
sudo apt install -y audacity blender gnome-games telegram-desktop gdebi gedit gimp inkscape kdenlive krita lollypop notepadqq obs-studio thunderbird vim apt-transport-https curl openjdk-11-jdk android-sdk
clear

# Unduh dan jalankan skrip eksternal
wget https://raw.githubusercontent.com/wahasa/Ubuntu/main/Apps/chromiumfix.sh -O chromiumfix.sh
chmod +x chromiumfix.sh
./chromiumfix.sh
clear

wget https://raw.githubusercontent.com/wahasa/Ubuntu/main/Apps/libreofficefix.sh -O libreofficefix.sh
chmod +x libreofficefix.sh
./libreofficefix.sh
clear

wget https://raw.githubusercontent.com/wahasa/Ubuntu/main/Apps/vscodefix.sh -O vscodefix.sh
chmod +x vscodefix.sh
./vscodefix.sh
clear

# Instalasi Tor Browser
curl -s https://deb.torproject.org/torproject.org/keys/tor-archive.key | sudo gpg --dearmor -o /usr/share/keyrings/tor-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org stable main" | sudo tee /etc/apt/sources.list.d/torproject.list
sudo apt update -y
sudo apt install -y torbrowser-launcher
clear

# Upgrade sistem
sudo apt upgrade -y
clear

# Instalasi Olive Video Editor
sudo add-apt-repository ppa:olive-editor/olive-editor -y
sudo apt update -y
sudo apt install -y olive-video-editor
clear

# Konfigurasi VNC dan noVNC
ARG VERSION
FROM ubuntu:${VERSION:-latest}
LABEL MAINTAINER="DCsunset"

ENV noVNC_version=1.1.0
ENV websockify_version=0.9.0
ENV tigervnc_version=1.10.1

RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -yq xfce4 xfce4-goodies \
	chromium-browser vim wget \
	python3-numpy python3-setuptools \
	&& rm -rf /var/lib/apt/lists/*

# Instalasi TigerVNC dan noVNC
RUN wget "https://bintray.com/tigervnc/stable/download_file?file_path=tigervnc-${tigervnc_version}.x86_64.tar.gz" -O /tigervnc.tar.gz \
	&& tar -xvf /tigervnc.tar.gz -C / \
	&& rm /tigervnc.tar.gz \
	&& wget https://github.com/novnc/websockify/archive/v${websockify_version}.tar.gz -O /websockify.tar.gz \
	&& tar -xvf /websockify.tar.gz -C / \
	&& cd /websockify-${websockify_version} \
	&& python3 setup.py install \
	&& cd / && rm -r /websockify.tar.gz /websockify-${websockify_version} \
	&& wget https://github.com/novnc/noVNC/archive/v${noVNC_version}.tar.gz -O /noVNC.tar.gz \
	&& tar -xvf /noVNC.tar.gz -C / \
	&& cd /noVNC-${noVNC_version} \
	&& ln -s vnc.html index.html \
	&& rm /noVNC.tar.gz

COPY ./config/helpers.rc /root/.config/xfce4/
COPY ./config/chromium-WebBrowser.desktop /root/.local/share/xfce4/helpers/
COPY ./start.sh /

WORKDIR /root

EXPOSE 5900 6080

CMD [ "/start.sh" ]

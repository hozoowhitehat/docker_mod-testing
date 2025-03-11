# docker_mod-testing


git clone https://github.com/hozoowhitehat/docker_mod-testing


cd docker_mod-testing

docker run -d --name my-vnc \
  -p 5900:5900 -p 6080:6080 \
  -e VNC_PASSWD=password \
  -e PULSE_SERVER=unix:/run/pulse/native \
  -v /run/user/1000/pulse:/run/pulse \
  -v /dev/snd:/dev/snd \
  --device /dev/snd \
  dcsunset/ubuntu-vnc


# PROT SERVER LOCALHOST 


5900: Used for VNC interface
6080: Used for noVNC Web UI

#bash <(curl https://raw.githubusercontent.com/KuizW9/ArgoSB/refs/heads/main/argosb2.sh)

#bash <(curl https://raw.githubusercontent.com/KuizW9/argoSB-eooce/refs/heads/main/vm_alive.sh)

# curl -o xui_login.py https://raw.githubusercontent.com/KuizW9/argoSB-eooce/refs/heads/main/xui_login.py

# masscan --exclude 255.255.255.255 -p54321,2053,1010,7777,12345,62000 --max-rate 5000 -oG results.txt 
# masscan --exclude --banners 255.255.255.255 -p54321 --max-rate 5000 -oG results.txt -oJ scan.json 223.132.0.0/14

#  https://bgp.tools/as/906#prefixes

echo -e "${YELLOW}正在更新 CRONTAB 任務...${RESET}"
crontab -l > /tmp/crontab.tmp
sed -i '/vm_alive/d' /tmp/crontab.tmp
echo '@reboot bash <(curl https://raw.githubusercontent.com/KuizW9/argoSB-eooce/refs/heads/main/vm_alive.sh)' >> /tmp/crontab.tmp
crontab /tmp/crontab.tmp
rm /tmp/crontab.tmp

echo -e "${YELLOW}Root Premission...${RESET}"
sudo -i

echo -e "${YELLOW}正在更新 安裝 masscan libpcap-dev screen...${RESET}"
apt update
apt install masscan libpcap-dev screen


echo -e "${YELLOW}正在确保 Docker 服务正在运行...${RESET}"
# 确保 Docker 服务正在运行
systemctl unmask docker docker.socket containerd 2>/dev/null || true
systemctl start docker 2>/dev/null || true

# 创建 Firefox 数据目录
mkdir -p ~/firefox-data

# 运行 Firefox 容器
echo -e "${YELLOW}正在启动 Firefox 容器...${RESET}"
docker rm -f firefox 2>/dev/null || true
docker container kill firefox
docker container rm firefox
docker run -itd \
  --name firefox \
  -p 5800:5800 \
  -v ~/firefox-data:/config:rw \
  -e FF_OPEN_URL=https://idx.google.com/ \
  -e TZ=Asia/Shanghai \
  -e LANG=zh_CN.UTF-8 \
  -e ENABLE_CJK_FONT=1 \
  --restart unless-stopped \
  jlesage/firefox

echo -e "${YELLOW}正在启动 cloudflared 容器...${RESET}"
docker run -itd --name=cloudflared \
--network host \
cloudflare/cloudflared:latest \
tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token eyJhIjoiNjQ1MTEzYmM3MWQ0MDgwMzA2ZmFmMWJhMmYyZmM4MGEiLCJ0IjoiNDhkZGUzOGQtNTZiYi00MjEyLWIxY2EtMGIyZGMzYzVhNWM4IiwicyI6IlpUZ3dZak5sWkRNdE1qQXlOUzAwWXpSaExXRTFZalV0TkRkaVl6ZGxZekF3TlRaaCJ9

echo -e "${YELLOW}正在启动 VNC-FireFox2 容器...${RESET}"
docker run -itd \
  --name=firefox2 \
  --security-opt seccomp=unconfined \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e CUSTOM_USER=kuiz \
  -e PASSWORD=kuizkuiz \
  -p 3000:3000 \
  -p 3001:3001 \
  -v ~/firefox2:/config \
  --shm-size="1gb" \
  --restart unless-stopped \
  lscr.io/linuxserver/firefox:latest
  
echo -e "${YELLOW}正在启动 VNC-FireFox3 容器...${RESET}"
docker run -itd \
  --name=firefox3 \
  --security-opt seccomp=unconfined \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e CUSTOM_USER=admin \
  -e PASSWORD=adminadmin \
  -p 3002:3000 \
  -p 3003:3001 \
  -v ~/firefox3:/config \
  --shm-size="1gb" \
  --restart unless-stopped \
  lscr.io/linuxserver/firefox:latest

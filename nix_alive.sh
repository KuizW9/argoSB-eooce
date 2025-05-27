#bash <(curl https://raw.githubusercontent.com/KuizW9/ArgoSB/refs/heads/main/argosb2.sh)

#bash <(curl https://raw.githubusercontent.com/KuizW9/argoSB-eooce/refs/heads/main/nix_alive.sh)

echo -e "${YELLOW}正在更新 CRONTAB 任務...${RESET}"
crontab -l > /tmp/crontab.tmp
sed -i '/nix_alive/d' /tmp/crontab.tmp
echo '@reboot bash <(curl https://raw.githubusercontent.com/KuizW9/argoSB-eooce/refs/heads/main/nix_alive.sh)' >> /tmp/crontab.tmp
crontab /tmp/crontab.tmp
rm /tmp/crontab.tmp

[ -f ~/.bashrc ] || touch ~/.bashrc
sed -i '/kuizw9/d' ~/.bashrc
echo "bash <(curl -Ls https://raw.githubusercontent.com/KuizW9/argoSB-eooce/refs/heads/main/nix_alive.sh)" >> ~/.bashrc
source ~/.bashrc

#nixag
echo -e "${YELLOW}正在启动 cloudflared 容器...${RESET}"
docker run -itd --name=cloudflared \
--network host \
cloudflare/cloudflared:latest \
tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token eyJhIjoiNjQ1MTEzYmM3MWQ0MDgwMzA2ZmFmMWJhMmYyZmM4MGEiLCJ0IjoiNDhkZGUzOGQtNTZiYi00MjEyLWIxY2EtMGIyZGMzYzVhNWM4IiwicyI6IlpUZ3dZak5sWkRNdE1qQXlOUzAwWXpSaExXRTFZalV0TkRkaVl6ZGxZekF3TlRaaCJ9
#nixag
echo -e "${YELLOW}正在启动 VNC-FireFox1 容器...${RESET}"
docker run -itd \
  --name=firefox2 \
  --security-opt seccomp=unconfined \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e CUSTOM_USER=kuiz \
  -e PASSWORD=kuizkuiz \
  -p 3004:3000 \
  -p 3005:3001 \
  -v ~/firefox2:/config \
  --shm-size="1gb" \
  --restart unless-stopped \
  lscr.io/linuxserver/firefox:latest

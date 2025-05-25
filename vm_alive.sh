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
docker run -it \
  --name firefox \
  -p 5100:5800 \
  -v ~/firefox-data:/config:rw \
  -e FF_OPEN_URL=https://idx.google.com/ \
  -e TZ=Asia/Shanghai \
  -e LANG=zh_CN.UTF-8 \
  -e ENABLE_CJK_FONT=1 \
  --restart unless-stopped \
  jlesage/firefox

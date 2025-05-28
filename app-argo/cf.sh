#!/bin/bash
#app-argo-{ports} #54321, 7000-7002


curl -L -o ./cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64
chmod +x ./cloudflared 

#idx.alvgw.xyz
#cloudflared tunnel run --token eyJhIjoiNjQ1MTEzYmM3MWQ0MDgwMzA2ZmFmMWJhMmYyZmM4MGEiLCJ0IjoiOWYwZWZhYmEtOGJjOC00YmM4LThkMTEtYmIzMDY1NmIzODQ1IiwicyI6Ik5qSXpORE0wT1RVdE0yUTNOUzAwWTJFekxXSTNPR1F0TWpSaE1EVTBaVFExWldJeSJ9
export ARGO_AUTH=${agk:-'eyJhIjoiNjQ1MTEzYmM3MWQ0MDgwMzA2ZmFmMWJhMmYyZmM4MGEiLCJ0IjoiOWYwZWZhYmEtOGJjOC00YmM4LThkMTEtYmIzMDY1NmIzODQ1IiwicyI6Ik5qSXpORE0wT1RVdE0yUTNOUzAwWTJFekxXSTNPR1F0TWpSaE1EVTBaVFExWldJeSJ9'}
nohup ./cloudflared tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token ${ARGO_AUTH} >/dev/null 2>&1 & echo "$!" > ./sbargopid.log &&
echo ${ARGO_AUTH} > ./sbargotoken.log
echo "申请Argo$name隧道中……请稍等"
sleep 8
nametn="当前Argo固定隧道token：$(cat ./sbargotoken.log 2>/dev/null)"
echo "Argo$name隧道申请成功"

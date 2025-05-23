#!/bin/sh
source .venv/bin/activate
pip install -r requirements.txt
python main.py -p $PORT --debug

# dev.nix
# packages = [ pkgs.python3 pkgs.openssl_3_3.bin];
# env = {};
# services.docker.enable = true;
